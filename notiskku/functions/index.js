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
    schedule: "*/30 * * * *", // 10분마다 실행
    timeZone: "Asia/Seoul",
  },
  async () => {
    logger.info("[실행] Firestore 데이터 확인 시작");

    try {
      const now = new Date();
      const thirtyMinutesAgo = new Date(now.getTime() - 30 * 60 * 1000);

      const notices = await db
        .collection("notices")
        .where("updated_at", ">=", thirtyMinutesAgo)
        .get();

      if (notices.empty) {
        logger.info("새로운 공지가 없습니다.");
        return;
      }

      for (const doc of notices.docs) {
        const data = doc.data();
        const { title, major, department } = data;

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
            title.includes(topicName) ||
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
            topic: topicId,
          };

          await messaging.send(message);
          logger.info(`'${mappedName}' (${topicId}) 푸시 전송 완료`);
        }
      }
    } catch (err) {
      logger.error("스케줄러 오류 발생:", err);
    }
  }
);
