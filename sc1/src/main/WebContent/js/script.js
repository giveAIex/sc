// 打开弹窗
function openLoginModal() {
    document.getElementById("loginModal").style.display = "block";
}

// 关闭弹窗
function closeLoginModal() {
    document.getElementById("loginModal").style.display = "none";
}

// 点击弹窗外部也可以关闭
window.onclick = function(event) {
    let modal = document.getElementById("loginModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
