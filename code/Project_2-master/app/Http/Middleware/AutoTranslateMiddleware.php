<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Stichoza\GoogleTranslate\GoogleTranslate;

class AutoTranslateMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        // หากภาษาเป็นอังกฤษ ไม่ต้องแปล
        if (App::getLocale() === 'en') {
            return $next($request);
        }

        $locale = App::getLocale();
        // สร้าง cache key สำหรับหน้าปัจจุบัน (รวม URI และ locale)
        $pageCacheKey = 'translated_page_' . md5($request->getRequestUri() . $locale);

        // ถ้ามีผลแปลของหน้าปัจจุบันใน cache อยู่แล้ว ให้นำมาใช้ทันที
        if (cache()->has($pageCacheKey)) {
            $response = $next($request);
            $response->setContent(cache()->get($pageCacheKey));
            return $response;
        }

        // ไม่พบใน cache ให้ทำการแปล
        $response = $next($request);
        $content = $response->getContent();

        // โหลด HTML ด้วย DOMDocument
        libxml_use_internal_errors(true);
        $dom = new \DOMDocument();
        $dom->loadHTML(mb_convert_encoding($content, 'HTML-ENTITIES', 'UTF-8'));
        libxml_clear_errors();

        // ใช้ DOMXPath เพื่อดึงทุก text node ที่มีข้อความ (รวมทุก tag)
        $xpath = new \DOMXPath($dom);
        $textNodes = $xpath->query('//text()[normalize-space()]');

        // เก็บข้อความไม่ซ้ำกันไว้ใน array เพื่อแปลเพียงครั้งเดียว
        $uniqueTexts = [];
        foreach ($textNodes as $node) {
            $text = $node->nodeValue;
            if (!empty(trim($text))) {
                $uniqueTexts[$text] = null;
            }
        }

        // สร้าง instance ของ GoogleTranslate สำหรับ target language ที่เลือก
        $translator = new GoogleTranslate($locale);

        // แปลข้อความที่ไม่ซ้ำกัน พร้อมใช้ caching แยกแต่ละข้อความ (เก็บ 24 ชั่วโมง)
        foreach ($uniqueTexts as $originalText => &$translatedText) {
            $cacheKey = 'translation_' . md5($originalText . $locale);
            $translatedText = cache()->remember($cacheKey, now()->addHours(24), function () use ($translator, $originalText) {
                return $translator->translate($originalText);
            });
        }
        unset($translatedText);

        // แทนที่ข้อความในทุก text node ด้วยผลการแปลที่ได้
        foreach ($textNodes as $node) {
            $original = $node->nodeValue;
            if (isset($uniqueTexts[$original])) {
                $node->nodeValue = $uniqueTexts[$original];
            }
        }

        // แปลง DOM กลับเป็น HTML
        $translatedContent = $dom->saveHTML();
        // เก็บผลลัพธ์ของการแปลทั้งหน้าไว้ใน cache (เช่น 10 นาที)
        cache()->put($pageCacheKey, $translatedContent, now()->addMinutes(10));

        $response->setContent($translatedContent);
        return $response;
    }
}
