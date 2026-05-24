(function() {
  let userScrolledUp = false;

  function getScrollEl() {
    return document.getElementById("viewport_scroll");
  }

  function isNearBottom(el) {
    if (!el) return true;
    return (el.scrollHeight - el.scrollTop - el.clientHeight) < 60;
  }

  function maybeAutoScroll() {
    const el = getScrollEl();
    if (!el) return;
    if (!userScrolledUp) {
      el.scrollTop = el.scrollHeight;
    }
  }

  function setupScrollWatcher() {
    const el = getScrollEl();
    if (!el || el.dataset.watcher === "1") return;
    el.dataset.watcher = "1";
    el.addEventListener("scroll", function() {
      userScrolledUp = !isNearBottom(el);
    });
  }

  function typewriter(node) {
    if (!node || node.dataset.typewriterStarted === "1") return;
    node.dataset.typewriterStarted = "1";
    const full = node.getAttribute("data-typewriter-content") || "";
    node.textContent = "";
    if (!full) return;
    // chunked: ~6 chars per tick @ 30ms
    let i = 0;
    const chunk = 6;
    function step() {
      i = Math.min(i + chunk, full.length);
      node.textContent = full.slice(0, i);
      maybeAutoScroll();
      if (i < full.length) {
        setTimeout(step, 30);
      }
    }
    step();
  }

  function activateTypewriters(root) {
    if (!root) return;
    const nodes = root.querySelectorAll("[data-typewriter='1']");
    nodes.forEach(typewriter);
  }

  function appendEvent(html, type) {
    const stream = document.getElementById("viewport_stream");
    if (!stream) return;
    const wrap = document.createElement("div");
    wrap.innerHTML = html;
    const node = wrap.firstElementChild;
    if (!node) return;
    node.classList.add("event-enter");
    stream.appendChild(node);
    // trigger animation on next frame
    requestAnimationFrame(function() {
      node.classList.add("event-enter-active");
    });
    activateTypewriters(node);
    maybeAutoScroll();
  }

  function resetStream() {
    const stream = document.getElementById("viewport_stream");
    if (stream) stream.innerHTML = "";
    userScrolledUp = false;
    const empty = document.getElementById("viewport_empty");
    if (empty) empty.style.display = "";
  }

  function bind() {
    if (!window.Shiny) {
      setTimeout(bind, 50);
      return;
    }
    setupScrollWatcher();
    Shiny.addCustomMessageHandler("replay_append", function(msg) {
      appendEvent(msg.html, msg.type);
    });
    Shiny.addCustomMessageHandler("replay_reset", function(msg) {
      resetStream();
    });
  }

  document.addEventListener("DOMContentLoaded", bind);
  bind();
})();
