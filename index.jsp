<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
        <title>Zoom Rotate Crop using Canvas</title>
        <script>

            $(function() {
                var destinationCanvas = document.getElementById('canvas2');
                var destinationCtx = destinationCanvas.getContext('2d');
                var canvas = document.getElementById('canvas');
                var image = document.getElementById('image');
                image.crossOrigin = "anonymous";
                var element = canvas.getContext("2d");
                var angleInDegrees = 0;
                var zoomDelta = 0.1;
                var currentScale = 1;
                var currentAngle = 0;
                var startX, startY, isDown = false;

                //load image in canvas
                element.translate(canvas.width / 2, canvas.height / 2);
                drawImage();
                jQuery('#canvas').attr('data-girar', 0);

//                jQuery('#carregar').click(function() {
//                    element.translate(canvas.width / 2, canvas.height / 2);
//                    drawImage();
//                    jQuery('#canvas').attr('data-girar', 0);
//                    this.disabled = true;
//                });

                jQuery('#giraresq').click(function() {
                    angleInDegrees = 90;
                    currentAngle += angleInDegrees;
                    drawImage();
                });

                jQuery('#girardir').click(function() {
                    angleInDegrees = -90;
                    currentAngle += angleInDegrees;
                    drawImage();
                });

                jQuery('#zoomIn').click(function() {
                    currentScale += zoomDelta;
                    drawImage();
                });
                jQuery('#zoomOut').click(function() {
                    currentScale -= zoomDelta;
                    drawImage();
                });

                canvas.onmousedown = function(e) {
                    var pos = getMousePos(canvas, e);
                    startX = pos.x;
                    startY = pos.y;
                    isDown = true;
                }

                canvas.onmousemove = function(e) {
                    if (isDown === true) {
                        var pos = getMousePos(canvas, e);
                        var x = pos.x;
                        var y = pos.y;

                        element.translate(x - startX, y - startY);
                        drawImage();

                        startX = x;
                        startY = y;
                    }
                }
                canvas.onmouseup = function(e) {
                    isDown = false;
                }

                function drawImage() {
                    clear();
                    element.save();
                    element.scale(currentScale, currentScale);
                    element.rotate(currentAngle * Math.PI / 180);
                    element.drawImage(image, -image.width / 2, -image.width / 2);
                    element.restore();
                }

                $("#cropimg").button().click(function() {
                    var y = $("#overlay").css("top");
                    var x = $("#overlay").css("left");
                    var width = $("#overlay").css("width");
                    var height = $("#overlay").css("height");
                    console.log(x + " : " + y + " : " + width + " : " + height);
                    croprectangle(parseInt(x.replace('px', '')), parseInt(y.replace('px', '')), parseInt(width.replace('px', '')), parseInt(height.replace('px', '')));
                });


                function croprectangle(x, y, width, height) {
                    console.log(x + " : " + y + " : " + width + " : " + height + " : " + parseInt(-250 + x) + " : " + parseInt(-250 + y));
                    var imageData = element.getImageData(x, y, width, height); //NOT translated corodinates X and Y only
                    destinationCtx.canvas.width = width;
                    destinationCtx.canvas.height = height;
                    destinationCtx.putImageData(imageData, 0, 0);
                    element.clearRect(-250, -250, 500, 500);
                    element.rect(parseInt(-250 + x), parseInt(-250 + y), width, height); //translated corodinates X and Y only
                    element.stroke();
                    element.clip();
                    element.save();
                    element.scale(currentScale, currentScale);
                    element.rotate(currentAngle * Math.PI / 180);
                    element.drawImage(image, -image.width / 2, -image.width / 2);
                    element.restore();
                }



                function clear() {
                    element.clearRect(-image.width / 2 - 2, -image.width / 2 - 2, image.width + 4, image.height + 4);
                }

                function getMousePos(canvas, evt) {
                    var rect = canvas.getBoundingClientRect();
                    return {
                        x: evt.clientX - rect.left,
                        y: evt.clientY - rect.top
                    };
                }

                $("#slider1").slider({min: 0, max: 360, value: 0});
                $("#slider1").slider({
                    slide: function(event, ui) {
                        $("#slideval1").html((ui.value));
                        currentAngle = ui.value;
                        drawImage();
                    }
                });

                $("#slider2").slider({min: 0, step: 0.01, max: 5, value: 1});
                $("#slider2").slider({
                    slide: function(event, ui) {
                        $("#slideval2").html((ui.value));
                        currentScale = ui.value;
                        drawImage();
                    }
                });
                $("#overlay").resizable({handles: "n, e, s, w, se, sw, nw, ne", containment: "#canvas-wrap"});
                $("#overlay").draggable({containment: "parent"});
            });

            function exportCanvas() {
                var mycanvas = document.getElementById("canvas2");
                if (mycanvas && mycanvas.getContext) {
                    var img = mycanvas.toDataURL("image/png;base64;");
                    window.open(img, "", "width=700,height=700");
                }
            }

        </script>

        <style>
            canvas {
                border:1px solid silver;
            }
            img {
                display:none;
            }
            #slider1, #slider2{
                width: 500px;
            }
            #canvas-wrap { position:relative } /* Make this a positioned parent */
            #overlay     { position:absolute; top:20px; left:30px;width:250px;height:250px; background-color: transparent;border:1px solid blue;}
        </style>
    </head>
    <body>
        <!--<button id="carregar" >Load Image</button>-->
        <!--        <button id="giraresq" style="display: none;">Rotate to Left</button>
                <button id="girardir" style="display: none;">Rotate to Right</button>
                <button id="zoomIn" style="display: none;">+ Zoom</button>
                <button id="zoomOut" style="display: none;">- Zoom</button>-->
        <div style="text-align: center;font: 26px bold sans-serif;">Zoom Rotate Crop using HTML 5 Canvas</div>
        <hr />
        <div id="canvas-wrap" style="width: 494px;height: 500px;">
            <canvas id="canvas" height="500" width="500" data-girar="0">

            </canvas>
            <div id="overlay"></div>
            <canvas id="canvas2" height="500" width="500" data-girar="0" style="top: 0px;position: absolute;left: 650px;" >

            </canvas>
        </div>

        <a href="javscript:void(0)" onclick="exportCanvas()" style="position: relative;left: 800px;">Export</a>
        <hr>
        <img src="image/image009.JPG" id="image" />
        <div style="padding-top: 18px;padding-left: 8px;">
            <span style="float: left;" >ROTATION : </span>
            <span id="slideval1" style="margin-left: 541px;position: absolute;"></span>   
            <div id="slider1" style="margin-left: 110px;"></div>
        </div>
        <div style="padding-top: 10px;padding-left: 8px;">
            <span style="float: left;" >ZOOM : </span>
            <div id="slideval2" style="margin-left: 628px;position: absolute;"></div>
            <div id="slider2" style="margin-left: 110px;"></div>
        </div>
        <div style="position: absolute;margin-top: 16px;">
            <a id="cropimg">Crop</a>
        </div>
    </body>
</html>
