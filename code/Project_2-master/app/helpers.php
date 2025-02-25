<?php


/**
 * MAKE AVATAR FUNCTION
 */
if (!function_exists('makeAvatar')) {
  function makeAvatar($fontPath, $dest, $char)
  {
    $path = $dest;
    $image = imagecreate(200, 200);
    $red = rand(0, 255);
    $green = rand(0, 255);
    $blue = rand(0, 255);
    imagecolorallocate($image, $red, $green, $blue);
    $textcolor = imagecolorallocate($image, 255, 255, 255);
    imagettftext($image, 100, 0, 50, 150, $textcolor, $fontPath, $char);
    imagepng($image, $path);
    imagedestroy($image);
    return $path;
  }
}

/**
 * TRANSLATE TEXT FUNCTION
 * ฟังก์ชันแปลข้อความ
 *
 * @param string $text ข้อความที่ต้องการแปล
 * @param string $sourceLang ภาษาต้นทางของข้อความ (default: 'en')
 * @return string ข้อความที่แปลแล้ว หรือข้อความเดิมหากเกิดข้อผิดพลาด
 */
if (!function_exists('translateText')) {
  function translateText($text, $sourceLang = 'en')
  {
    // ตรวจสอบค่า null หรือค่าว่าง
    if ($text === null || trim($text) === '') {
      return '';
    }

    // แปลงค่าให้เป็น string อย่างชัดเจน
    $text = (string)$text;

    // ดึง target language จาก locale ปัจจุบันของแอปพลิเคชัน
    $targetLang = app()->getLocale();

    // ถ้า target language เท่ากับภาษาต้นทาง ไม่ต้องแปล
    if ($targetLang === $sourceLang) {
      return $text;
    }

    try {
      // สร้าง instance โดยระบุ target language และภาษาต้นทาง
      $tr = new \Stichoza\GoogleTranslate\GoogleTranslate($targetLang, $sourceLang);
      return $tr->translate($text);
    } catch (\Exception $e) {
      \Log::error('Translation error: ' . $e->getMessage());
      return $text;
    }
  }
}
