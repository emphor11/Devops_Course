async function refreshHealth() {
  const statusDot = document.getElementById('status-dot');
  const statusValue = document.getElementById('status-value');
  const message = document.getElementById('message');
  const timestamp = document.getElementById('timestamp');

  try {
    const response = await fetch('/health');
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();
    statusDot.className = 'status-dot ok';
    statusValue.textContent = data.status;
    message.textContent = data.message;
    timestamp.textContent = data.timestamp;
  } catch (error) {
    statusDot.className = 'status-dot error';
    statusValue.textContent = 'unavailable';
    message.textContent = error.message;
    timestamp.textContent = '-';
  }
}

refreshHealth();
setInterval(refreshHealth, 30000);
