function formatNumber(number) {
    return number < 10 ? "0" + number : number;
}
 
function setTimer(){
    let tijd = new Date();
    document.getElementById("tijd").innerText = '';
    document.getElementById("tijd").innerText += formatNumber(tijd.getHours()) + ':';
    document.getElementById("tijd").innerText += formatNumber(tijd.getMinutes()) + ':';
    document.getElementById("tijd").innerText += formatNumber(tijd.getSeconds()) + '';
    setTimeout(setTimer,1000);
}

setTimer();