(function updateClock() {
    var now = new Date(),
    today = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));

    this.style.webkitTransform = 'rotate(' + Math.round((now - today) / 1000 / 86400 * 360) + 'deg)';
    
    setTimeout(updateClock.bind(this), 24000);
}).call(document.querySelector('.inner'));
