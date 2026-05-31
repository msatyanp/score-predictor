"""Email delivery service using SMTP (async-friendly via run_in_executor)."""

import asyncio
import logging
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from functools import partial

from app.core.config import settings

logger = logging.getLogger(__name__)

# ── Shared email CSS ──────────────────────────────────────────────────────────

_EMAIL_STYLE = """
<style>
  body { font-family: Arial, sans-serif; color: #333; margin: 0; padding: 20px; }
  table { border-collapse: collapse; width: 100%; margin-top: 12px; }
  th, td { border: 1px solid #c3c3c3; padding: 8px 12px; text-align: center; }
  th { background: #1E293B; color: #fff; text-transform: capitalize; }
  tr:nth-child(even) { background: #f7f8f5; }
  .not-predicted { background: #f7c6c6; color: #7f1d1d; font-weight: bold; }
  .btn { display: inline-block; margin-top: 16px; padding: 10px 20px;
         background: #15803D; color: #fff; border-radius: 6px;
         text-decoration: none; font-weight: bold; }
</style>
"""


def _build_base_html(body_content: str) -> str:
    """Wrap body content in the shared email HTML shell."""
    return f"""<html><head>{_EMAIL_STYLE}</head><body>
{body_content}
<br>
<p>For more details visit
  <a class="btn" href="{settings.SITE_URL}" target="_blank">Match Predictor</a>.
</p>
<p>Regards,<br><strong>Admin</strong></p>
</body></html>"""


def _send_sync(
    subject: str,
    html_body: str,
    recipients: list[str],
) -> None:
    """Blocking SMTP send — called from a thread pool by the async wrapper."""
    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = settings.EMAIL_FROM
    msg["To"] = ", ".join(recipients)
    msg.attach(MIMEText(html_body, "html"))

    with smtplib.SMTP(settings.EMAIL_SMTP, settings.EMAIL_PORT) as mail:
        mail.starttls()
        mail.login(settings.EMAIL_FROM, settings.EMAIL_PASS)
        mail.sendmail(settings.EMAIL_FROM, recipients, msg.as_string())


async def send_email(
    subject: str,
    html_body: str,
    recipients: list[str],
) -> None:
    """Send an HTML email asynchronously (offloads SMTP to thread pool)."""
    if not recipients:
        logger.warning("send_email called with empty recipient list – skipping")
        return

    loop = asyncio.get_event_loop()
    try:
        await loop.run_in_executor(
            None,
            partial(_send_sync, subject, html_body, recipients),
        )
        logger.info("Email sent: %s → %d recipient(s)", subject, len(recipients))
    except Exception:
        logger.exception("Failed to send email: %s", subject)
        raise


def build_base_html(body_content: str) -> str:
    """Public alias so scheduler jobs can call this without importing the private name."""
    return _build_base_html(body_content)
