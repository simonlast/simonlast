/**
 * @author Simon Last
 */


canvas = document.getElementById("platform");
var ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = 400;

ctx.fillStyle = '#0';
ctx.font = '80px Helvetica';
ctx.textBaseline = 'bottom';
ctx.fillText('This is a Photo Diary', 50, 100);