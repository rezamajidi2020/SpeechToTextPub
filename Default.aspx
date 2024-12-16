<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Real-Time Speech Recognition</title>

    <%--<script src="main.js"></script>
    <script src="/Scripts/socket.io.min.js"></script>
    <script src="/Scripts/socket.io-client.js"></script>--%>
    <%--<script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.0.0/socket.io.min.js"></script> <!-- Include socket.io library -->--%>

    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.3.min.js"></script>
    <%--<script src="Scripts/jquery.signalR-2.4.3.js"></script>--%>
    <script src="/signalr/hubs"></script>
    <link href="Css/Icon.css" rel="stylesheet" />

    <style>
        html, body {
            height: 100%;
        }

        .wrap {
            height: 20%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .button {
            min-width: 90px;
            min-height: 90px;
            display: inline-flex;
            font-size: 18px;
            align-items: center;
            justify-content: center;
            text-transform: uppercase;
            text-align: center;
            letter-spacing: 1.3px;
            font-weight: 700;
            color: #313133;
            background: #4FD1C5;
            background: linear-gradient(90deg, rgba(129,230,217,1) 0%, rgba(79,209,197,1) 100%);
            border: none;
            border-radius: 1000px;
            box-shadow: 12px 12px 24px rgba(79,209,197,.64);
            transition: all 0.3s ease-in-out 0s;
            cursor: pointer;
            outline: none;
            position: relative;
            padding: 10px;
        }

            .button::before {
                content: '';
                border-radius: 1000px;
                min-width: calc(90px + 12px);
                min-height: calc(90px + 12px);
                border: 6px solid #00FFCB;
                box-shadow: 0 0 90px rgba(0,255,203,.64);
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                opacity: 0;
                transition: all .3s ease-in-out 0s;
            }

            .button:hover,
            .button:focus {
                color: #313133;
                transform: translateY(-6px);
            }

                .button:hover::before,
                .button:focus::before {
                    opacity: 1;
                }

            .button::after {
                content: '';
                width: 30px;
                height: 30px;
                border-radius: 100%;
                border: 6px solid #00FFCB;
                position: absolute;
                z-index: -1;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                animation: ring 1.5s infinite;
            }

            .button:hover::after,
            .button:focus::after {
                animation: none;
                display: none;
            }

        @keyframes ring {
            0% {
                width: 30px;
                height: 30px;
                opacity: 1;
            }

            100% {
                width: 150px;
                height: 150px;
                opacity: 0;
            }
        }
       @font-face {
            font-family: 'BNazanin';
            src: url('./fonts/BNazanin.ttf') format('truetype');
        }

        body {
            font-family: 'BNazanin', BNazanin;
        }
    </style>
</head>
<body style="text-align: center; font-family: BNazanin">
    <h2>تبدیل گفتار به متن</h2>
    <div class="wrap">
        <%--<button id="startBtn" class="button fa fa-microphone">شروع</button>--%>
        <button id="startBtn" class="button">شروع</button>
    </div>
    <%--<button id="startBtn" style="width: 100px; height: 100px; border-radius: 50%">شروع صحبت کردن</button>--%>
    <%--<button id="stopBtn">پایان صحبت کردن</button>--%>
    <br />
    <%--<div id="transcription"></div>--%>
    <%--<input id="transcription" type="text" style="width: 700px; height: 400px; margin-top:15px"/>--%>
    <textarea id="transcription" name="multiText" rows="5" cols="30" 
        style="width: 700px; max-height: 400px; max-width: 700px; min-height: 400px; min-width: 700px; height: 400px; margin-top: 15px;
        font-size:18px"
        ></textarea><br>
    <%--<input id="transcription" style="width: 300px; height: 100px" aria-multiline="true" />--%>

    <%--Not True--%>
    <%--<script type="module">
        import http from 'http';
        import fs from 'fs';
        import Readable from 'stream';
        import vosk from 'vosk';

        // Path to your Vosk model
        const MODEL_PATH = "vosk";
        const SAMPLE_RATE = 16000;

        if (!fs.existsSync(MODEL_PATH)) {
            console.error(`Model not found at ${MODEL_PATH}`);
            process.exit(1);
        }

        // Load the Vosk model
        const model = new vosk.Model(MODEL_PATH);

        http.createServer((req, res) => {
            if (req.method === "POST" && req.url === "/ProcessAudio") {
                const audioChunks = [];
                req.on('data', (chunk) => {
                    audioChunks.push(chunk);
                });

                req.on('end', () => {
                    const audioBuffer = Buffer.concat(audioChunks);

                    // Create a readable stream for Vosk
                    const audioStream = new Readable();
                    audioStream.push(audioBuffer);
                    audioStream.push(null);

                    try {
                        const rec = new vosk.Recognizer({ model: model, sampleRate: SAMPLE_RATE });

                        // Process audio data in chunks
                        audioStream.on('data', (chunk) => {
                            rec.acceptWaveform(chunk);
                        });

                        audioStream.on('end', () => {
                            const result = rec.finalResult();
                            rec.free(); // Free Vosk resources

                            res.writeHead(200, { "Content-Type": "application/json" });
                            res.end(JSON.stringify(result));
                        });
                    } catch (err) {
                        console.error("Error processing audio:", err);
                        res.writeHead(500, { "Content-Type": "application/json" });
                        res.end(JSON.stringify({ error: "Error processing audio" }));
                    }
                });
            } else {
                res.writeHead(404, { "Content-Type": "text/plain" });
                res.end("Not Found");
            }
        }).listen(3000, () => {
            console.log("Server is running on http://localhost:3000");
        });
    </script>--%>
    <%--Not True--%>
    <%--  <script>
        var Flag = 1;
        let audioChunks = [];
        let mediaRecorder;
        const connection = $.connection.speechRecognitionHub

        connection.on('ReceiveMessage', function (recognizedText) {
            //console.log('36');
            //console.log(recognizedText);

            document.getElementById('transcription').innerText =
                document.getElementById('transcription').innerText +
                '\r\n' + (JSON.parse(recognizedText)).text + '';
        });

        async function startRecording() {
            mediaRecorder = null;
            const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
            mediaRecorder = new MediaRecorder(stream);

            mediaRecorder.ondataavailable = (event) => {
                console.log('437 : ');
                console.log(event.data);
                audioChunks = [];
                audioChunks.push(event.data);
            };


            mediaRecorder.onstop = () => {
                onStopFunction();
            };

            mediaRecorder.start();
        }

        function stopRecording() {
            if (mediaRecorder) {
                mediaRecorder.stop();
            }
        }

        function CheckMediaRecorderStatus() {
            if (mediaRecorder != null && mediaRecorder.state === 'recording' && Flag === 2) {
                Flag = 1;
                onStopFunction();
            }
        }


        function onStopFunction() {
            const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
            const reader = new FileReader();
            reader.onload = function (e) {
                const base64Audio = e.target.result.split(',')[1]; // Extract Base64 data
                sendAudioToServer(base64Audio);
                if (Flag === 1 && mediaRecorder.state === 'inactive') {
                    Flag = 2;
                    mediaRecorder.start();
                }
            };
            reader.readAsDataURL(audioBlob);
        }

        const intervalId = setInterval(CheckMediaRecorderStatus, 5000);

        function sendAudioToServer(base64Audio) {
            $.connection.hub.start({ transport: ['serverSentEvents', 'longPolling'] }).done(function () {
                if ($.connection.hub.state === $.signalR.connectionState.connected) {
                    console.log("SignalR connected!");
                    connection.server.processAudio(base64Audio);
                } else {
                    console.error("SignalR connection is not active.");
                }
            }).fail(function (error) {
                console.error("SignalR connection failed:", error);
            });
        }

        async function eventHandler() {
            if (Flag === 1) {
                document.getElementById('startBtn').innerText = 'پایان';
                startRecording();
                Flag = 2;
            } else {
                document.getElementById('startBtn').innerText = 'شروع';
                Flag = 1;
                stopRecording();
            }
        }

        document.getElementById('startBtn').addEventListener('click', eventHandler);
    </script>--%>
    <%--// true--%>
    <script>
        var Flag = 1;
        let audioChunks = [];
        let mediaRecorder;
        const connection = $.connection.speechRecognitionHub

        //connection.client.receiveMessage = function (recognizedText) {
        //    document.getElementById('transcription').innerHTML = recognizedText;
        //};

        connection.on('ReceiveMessage', function (recognizedText) {
            document.getElementById('transcription').innerHTML =
                document.getElementById('transcription').innerHTML +
                ' ' + (JSON.parse(recognizedText)).text + '';
        });


        async function startRecording() {
            mediaRecorder = null;
            const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
            mediaRecorder = new MediaRecorder(stream);

            mediaRecorder.ondataavailable = (event) => {
                audioChunks = [];
                audioChunks.push(event.data);
            };
            mediaRecorder.onstop = () => {
                const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
                const reader = new FileReader();

                reader.onload = function (e) {
                    const base64Audio = e.target.result.split(',')[1]; // Extract Base64 data
                    sendAudioToServer(base64Audio);
                };
                reader.readAsDataURL(audioBlob);
            };

            mediaRecorder.start();
        }

        function stopRecording() {
            if (mediaRecorder) {
                mediaRecorder.stop();
            }
        }

        function sendAudioToServer(base64Audio) {
            $.connection.hub.start({ transport: ['serverSentEvents', 'longPolling'] }).done(function () {
                if ($.connection.hub.state === $.signalR.connectionState.connected) {
                    console.log("SignalR connected!");
                    connection.server.processAudio(base64Audio);
                } else {
                    console.error("SignalR connection is not active.");
                }
            }).fail(function (error) {
                console.error("SignalR connection failed:", error);
            });
        }

        async function eventHandler() {
            if (Flag === 1) {
                document.getElementById('startBtn').innerText = 'پایان';
                startRecording();
                Flag = 2;
            } else {
                document.getElementById('startBtn').innerText = 'شروع';
                stopRecording();
                Flag = 1;
            }
        }

        document.getElementById('startBtn').addEventListener('click', eventHandler);
        //document.getElementById('stopBtn').addEventListener('click', stopRecording);


        //const connection = $.connection.speechRecognitionHub;

        //connection.client.receiveSpeech = function (recognizedText) {
        //    console.log("Recognized Text: ", recognizedText);
        //    $("#transcription").text(recognizedText);
        //};

        //$.connection.hub.start().done(() => {
        //    console.log("SignalR connected!");

        //    // Send audio data to the server
        //    const audioBase64 = "base64EncodedAudio"; // Replace with actual audio data
        //    connection.server.sendAudio(audioBase64);
        //});





        //////Protocol: Use ws:// for non-secure connections and wss:// for secure connections.
        //let socket = new WebSocket('ws://localhost:57805/Hubs/ReceiveAudio');  // Connect to the WebSocket server

        //let mediaRecorder;
        //let audioChunks = [];

        //document.getElementById('startBtn').onclick = function () {
        //    navigator.mediaDevices.getUserMedia({ audio: true })
        //        .then(function (stream) {
        //            mediaRecorder = new MediaRecorder(stream);
        //            mediaRecorder.ondataavailable = function (event) {
        //                audioChunks.push(event.data);
        //                if (mediaRecorder.state === "inactive") {
        //                    let audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
        //                    let reader = new FileReader();
        //                    reader.onload = function () {
        //                        alert('40 :');
        //                        let base64Audio = reader.result.split(',')[1]; // Get base64 encoded audio
        //                        socket.send(base64Audio);  // Send audio data to the server
        //                    };
        //                    reader.readAsDataURL(audioBlob);
        //                    console.log("reader: ");
        //                    console.log(reader);
        //                }
        //            };

        //            // Start recording audio
        //            mediaRecorder.start(1000);  // Collect audio every 1 second
        //            console.log("Recording started...");

        //            // Stop after 10 seconds for demo purposes (you can control this as needed)
        //            setTimeout(function () {
        //                mediaRecorder.stop();
        //                console.log("Recording stopped.");
        //            }, 10000);  // Stop after 10 seconds
        //        })
        //        .catch(function (err) {
        //            console.log("Error: " + err);
        //        });
        //};

        // Handle server response for transcription updates
        //socket.onmessage = function (event) {
        //    let transcription = event.data;
        //    document.getElementById('transcription').innerText = transcription; // Display transcription
        //};
    </script>
    <%--Not True--%>
    <%--<script type="module">
        import { io } from 'socket.io-client';
        let socket = io.connect('http://localhost:57805');  // Connect to the server-side socket.io

        // Start button to begin capturing audio
        document.getElementById('startBtn').onclick = startRecording;

        let mediaRecorder;
        let audioChunks = [];

        function startRecording() {
            // Request access to the microphone
            navigator.mediaDevices.getUserMedia({ audio: true })
                .then(stream => {
                    mediaRecorder = new MediaRecorder(stream);
                    mediaRecorder.ondataavailable = event => {
                        audioChunks.push(event.data);  // Store audio data
                        if (mediaRecorder.state === "inactive") {
                            // Send audio data to the server when recording is stopped
                            let audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
                            let reader = new FileReader();
                            reader.onload = function () {
                                // Send audio data as base64 encoded string to the server
                                socket.emit('audioData', reader.result);
                            };
                            reader.readAsDataURL(audioBlob);
                        }
                    };

                    // Start recording
                    mediaRecorder.start(1000);  // Collect audio every 1 second
                    console.log('Recording started...');
                    document.getElementById('transcription').innerHTML = "Listening...";

                    // Stop recording after 10 seconds for demo (or add logic to stop recording when user clicks stop)
                    setTimeout(() => {
                        mediaRecorder.stop();
                        console.log('Recording stopped.');
                    }, 10000);  // Stop after 10 seconds
                })
                .catch(err => {
                    console.error("Error accessing the microphone: ", err);
                    document.getElementById('transcription').innerHTML = "Error accessing microphone.";
                });
        }

        // Listen for transcription data from the server and update UI
        socket.on('transcription', function (data) {
            document.getElementById('transcription').innerHTML = data;
        });
    </script>--%>
</body>
</html>
