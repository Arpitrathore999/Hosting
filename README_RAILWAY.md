# CloudBot - Railway deployment

This package is prepared for Railway with a Dockerfile and Node.js support for uploaded `.js` projects.

## Required Railway Variables
- `BOT_TOKEN`: create/revoke a Telegram bot token and put the NEW token here.
- `OWNER_ID`: your numeric Telegram user ID.

## Recommended variables
- `ADMIN_ID=0`
- `ALLOW_USER_EXECUTION=false` (secure default)
- `FORWARD_UPLOADS_TO_OWNER=false`
- `DATA_DIR=/data` if a Railway Volume is mounted at `/data`.

## Important security change
The hosting bot token and owner/admin IDs are no longer hard-coded into the Python source. Uploaded child processes also do not inherit the hosting bot's secret environment variables.

By default, non-admin users can upload files but their code is NOT executed and their dependency files are NOT installed. This prevents an untrusted uploader from immediately executing arbitrary code inside the Railway service.

If you enable `ALLOW_USER_EXECUTION=true`, understand that this is a code-hosting service: uploaded Python/Node code can potentially consume CPU/RAM, make network requests, and abuse the container. For genuinely untrusted users, use a separate sandbox/worker architecture instead of running their code in the bot container.

## Persistence
Without a Railway Volume, files under `DATA_DIR` are not guaranteed to survive redeployments/replacements. With a Volume mounted at `/data`, keep `DATA_DIR=/data` so uploads and the SQLite DB are stored there.

## Deploy
1. Upload this ZIP to a GitHub repo or deploy from the repo.
2. Create a Railway service from the repo.
3. Add the variables above.
4. Optional: attach a Railway Volume mounted at `/data` and set `DATA_DIR=/data`.
5. Deploy.

The service starts with `python cloudbot.py` and exposes the Flask health endpoint on Railway's `PORT`.
