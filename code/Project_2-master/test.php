<?php

require 'vendor/autoload.php';

use Stichoza\GoogleTranslate\GoogleTranslate;

echo GoogleTranslate::trans("Good bye", "th") . "\n";
echo GoogleTranslate::trans("ลาก่อน", "eng") . "\n";
echo GoogleTranslate::trans("Good bye", "zh-CN") . "\n";

