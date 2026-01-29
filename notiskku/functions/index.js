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
    schedule: "*/30 * * * *",
    timeZone: "Asia/Seoul",
  },
  async () => {
    logger.info("[실행] Firestore 데이터 확인 시작");

    try {
      const now = new Date();
      const thirtyMinutesAgo = new Date(now.getTime() - 30 * 60 * 1000);

      const noticesSnap = await db
        .collection("notices")
        .where("updated_at", ">=", thirtyMinutesAgo)
        .where("push_sent", "!=", true)
        .get();

      if (noticesSnap.empty) {
        logger.info("새로운 공지가 없습니다.");
        return;
      }

      const topicSnap = await db.collection("topic").get();
      const topicMap = {}; // topicId -> topicName
      const topicEntries = []; // [{ id, name }]

      topicSnap.forEach((doc) => {
        const name = doc.data().topic;
        topicMap[doc.id] = name;
        topicEntries.push({ id: doc.id, name });
      });

      for (const doc of noticesSnap.docs) {
        const data = doc.data();
        const { title, major, department, url, type } = data;

        if (!title) {
          logger.warn(`공지 ${doc.id}에 title 누락`);
          continue;
        }

        const matchedTopics = new Set();

        for (const { id, name } of topicEntries) {
          if (
            (type === "전체" && title.includes(name)) ||
            major === name ||
            department === name
          ) {
            matchedTopics.add(id);
          }
        }

        if (matchedTopics.size === 0) {
          logger.info(`공지 '${title}'은 알림 대상 없음`);
          continue;
        }

        let allSuccess = true;

        for (const topicId of matchedTopics) {
          const mappedName = topicMap[topicId] ?? topicId;

          const message = {
            notification: {
              title: `${mappedName} 관련 공지사항`,
              body: title,
            },
            data: { url },
            topic: topicId,
          };

          try {
            await messaging.send(message);
            logger.info(`'${mappedName}' (${topicId}) 푸시 전송 완료`);
          } catch (e) {
            allSuccess = false;
            logger.error(`푸시 전송 실패 (${topicId})`, e);
          }
        }

        if (allSuccess) {
          await db.collection("notices").doc(doc.id).update({
            push_sent: true,
            push_sent_at: new Date(),
          });
          logger.info(`공지 '${title}' push_sent 처리 완료`);
        } else {
          logger.warn(`공지 '${title}' 일부 푸시 실패 → 재시도 대기`);
        }
      }
    } catch (err) {
      logger.error("스케줄러 오류 발생:", err);
    }
  }
);
