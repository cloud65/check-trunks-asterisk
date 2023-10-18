# check-trunks-asterisk
Проверка регистрации транков Asterisk

Добавляем в Cron (crontab -e)

*/5 * * * * /etc/scripts/check.sh <chat_id> <telegram_bot_token>
