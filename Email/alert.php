<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

require 'phpmailer/src/Exception.php';
require 'phpmailer/src/PHPMailer.php';
require 'phpmailer/src/SMTP.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    date_default_timezone_set('Africa/Cairo'); 
     $current_time_english = date('Y-m-d H:i:s T'); 


    $gas_level = isset($_POST['gas_level']) ? $_POST['gas_level'] : 'High';

    $mail = new PHPMailer(true);
    try {
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'srorr8872@gmail.com';  
        $mail->Password   = 'illy vste zxgh mdmp'; 
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
        $mail->Port       = 465;

        $mail->setFrom('srorr8872@gmail.com', 'GasLevel Pro System');
        $mail->addAddress('srorr8872@gmail.com');
        $mail->addAddress('mohamedmm6723423@gmail.com');
        $mail->isHTML(true);
        $mail->Subject = mb_encode_mimeheader('🔴 Gas System Alert Message', 'UTF-8');
      
        $message = '
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <style>
                * {
                    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
                    box-sizing: border-box;
                }
                body {
                    margin: 0;
                    padding: 20px;
                    background: #f8f9fa;
                }
                .email-wrapper {
                    max-width: 700px;
                    margin: 0 auto;
                    background: #ffffff;
                    border-radius: 16px;
                    overflow: hidden;
                    box-shadow: 0 8px 24px rgba(0,0,0,0.08);
                }
                .alert-header {
                    background: linear-gradient(135deg, #ff4b4b, #d32f2f);
                    padding: 32px;
                    text-align: center;
                }
                .alert-title {
                    color: white;
                    font-size: 28px;
                    margin: 0 0 15px 0;
                    font-weight: 700;
                    letter-spacing: -0.5px;
                }
                .alert-level {
                    background: rgba(255,255,255,0.15);
                    display: inline-block;
                    padding: 8px 20px;
                    border-radius: 20px;
                    font-weight: 600;
                    font-size: 16px;
                }
                .content-section {
                    padding: 40px;
                    text-align: center;
                }
                .gauge-container {
                    width: 200px;
                    height: 200px;
                    margin: 0 auto 30px;
                    position: relative;
                    background: conic-gradient(
                        #4CAF50 0% 30%,
                        #FFC107 30% 70%,
                        #D32F2F 70% 100%
                    );
                    border-radius: 50%;
                    padding: 20px;
                }
                .inner-gauge {
                    width: 160px;
                    height: 160px;
                    background: white;
                    border-radius: 50%;
                    position: absolute;
                    top: 20px;
                    left: 20px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 32px;
                    font-weight: 700;
                    color: #d32f2f;
                    box-shadow: inset 0 4px 12px rgba(0,0,0,0.1);
                }
                .details-box {
                    background: #fff9f9;
                    border: 1px solid #ffe5e5;
                    border-radius: 12px;
                    padding: 20px;
                    margin: 25px 0;
                    text-align: left;
                }
                .detail-item {
                    display: flex;
                    justify-content: space-between;
                    margin: 12px 0;
                    color: #555;
                }
                .cta-button {
                    display: inline-block;
                    background:rgb(0, 255, 30);
                    color: white !important;
                    padding: 14px 32px;
                    text-decoration: none;
                    border-radius: 8px;
                    font-weight: 600;
                    margin: 20px 0;
                    transition: transform 0.2s;
                }
                .cta-button:hover {
                    transform: translateY(-2px);
                }
                .footer {
                    background: #f8f9fa;
                    padding: 25px;
                    text-align: center;
                    color: #666;
                    font-size: 13px;
                }
            </style>
        </head>
        <body>
            <div class="email-wrapper">
                <div class="alert-header">
                    <h1 class="alert-title">GAS LEAK DETECTED</h1>
                    <div class="alert-level">CRITICAL LEVEL</div>
                </div>
                
                <div class="content-section">
                    <div class="gauge-container">
                        <div class="inner-gauge">
                           🔥'.htmlspecialchars($gas_level).' ppm
                        </div>
                    </div>
                    
                    <h2 style="color: #d32f2f; margin: 0 0 8px 0;">Evacuation Recommended</h2>
                    <p style="color: #666; line-height: 1.6; max-width: 500px; margin: 0 auto;">
                        Our sensors detected dangerous gas concentration levels exceeding safety thresholds. 
                        Immediate evacuation and ventilation of the area is strongly recommended.
                    </p>
                    
                    <div class="details-box">
                        <div class="detail-item">
                            <span>Detection Time:</span>
                          <span>' . htmlspecialchars($current_time_english) . '</span>
                        </div>
                        <div class="detail-item">
                            <span>Sensor ID:</span>
                            <span>GS-2245-KSA</span>
                        </div>
                        <div class="detail-item">
                            <span>Location:</span>
                            <span>Bathroom Gas Heater - Residential House</span>
                        </div>
                    </div>
                    
                    <a href="#" class="cta-button"> Stay Away </a>
                    
                    <p style="color: #888; font-size: 14px;">
                        Need assistance? Contact our 24/7 safety team: 
                        <a href="tel:+201141572180" style="color: #d32f2f; text-decoration: none;">
                            +201141572180
                        </a>
                    </p>
                </div>
                
                <div class="footer">
                    <p>This is an automated alert from GasLevel Pro System</p>
                    <p>© 2025 Safety Solutions Inc. •Zagazig </a>
                    <p>
                        <a href="#" style="color: #666; text-decoration: none; margin: 0 10px;">System Manual</a> •
                        <a href="#" style="color: #666; text-decoration: none; margin: 0 10px;">Privacy Policy</a>
                    </p>
                </div>
            </div>
        </body>
        </html>
        ';

        $mail->Body = $message;
        $mail->send();
        echo 'Email has been sent ✅👌😊😁😍 ';
    } catch (Exception $e) {
        echo "Error: {$mail->ErrorInfo}";
    }
} else {
    echo "Invalid request.";
}
?>