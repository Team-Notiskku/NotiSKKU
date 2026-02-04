const { onSchedule } = require("firebase-functions/v2/scheduler");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();
const db = getFirestore();
const messaging = getMessaging();

exports.scheduledPushNotification = onSchedule(
  {
    schedule: "*/30 * * * *", // 30분마다 실행
    timeZone: "Asia/Seoul",
  },
  async () => {
    logger.info("[실행] Firestore 데이터 확인 시작");

    try {
      const now = new Date();
      const thirtyMinutesAgo = new Date(now.getTime() - 30 * 60 * 1000);

      const notices = await db
      .collection("notices")
      .where("push_sent", "==", false)
      .get();


      if (notices.empty) {
        logger.info("새로운 공지가 없습니다.");
        return;
      }

      const filtered = notices.docs.filter(doc => {
        const updatedAt = doc.data().updated_at?.toDate?.();
        return updatedAt && updatedAt >= thirtyMinutesAgo;
      });

      if (filtered.length === 0) {
        logger.info("30분 이내 새로운 공지가 없습니다.");
        return;
      }

      for (const doc of filtered) {
        const data = doc.data();
        const { title, major, department, url } = data;

        if (!title) {
          logger.warn(`공지 ${doc.id}에 title 누락`);
          continue;
        }

        let matchedTopics = [];

        const topicDocs = await db.collection("topic").get();
        topicDocs.forEach((t) => {
          const tdata = t.data();
          const topicId = t.id;
          const topicName = tdata.topic;

          if (
            (title.includes(topicName) && data.type == "전체") ||
            major === topicName ||
            department === topicName
          ) {
            matchedTopics.push(topicId);
          }
        });

        matchedTopics = [...new Set(matchedTopics)];

        if (matchedTopics.length === 0) {
          logger.info(`공지 '${title}'은 알림 대상 없음`);
          continue;
        }

        for (const topicId of matchedTopics) {
          const topicDoc = await db.collection("topic").doc(topicId).get();
          const mappedName = topicDoc.exists
            ? topicDoc.data().topic
            : topicId;

          const message = {
            notification: {
              title: `${mappedName} 관련 공지사항`,
              body: title,
            },
            data: {
              url: url, 
            },
            topic: topicId,
          };

          await messaging.send(message);
          logger.info(`'${mappedName}' (${topicId}) 푸시 전송 완료`);
        }

        await db.collection("notices").doc(doc.id).update({
          push_sent: true,
          push_sent_at: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    } catch (err) {
      logger.error("스케줄러 오류 발생:", err);
    }
  }
);