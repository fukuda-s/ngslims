<?php

/**
 * PHP functions used from Volt, accepting null like PHP 7.
 *
 * PHP 8.1 deprecates passing null to built-in functions' scalar parameters.
 * Templates pass null columns (prices, dates) to them, so cast null the way PHP 7 did.
 */
class LegacyFunctions
{
    public static function numberFormat($num, ...$args): string
    {
        return number_format((float)$num, ...$args);
    }

    public static function strtotime($datetime, $baseTimestamp = null)
    {
        return strtotime((string)$datetime, $baseTimestamp);
    }

    /**
     * "string" filter of Phalcon 3 (FILTER_SANITIZE_STRING, removed in PHP 8.1): strip tags and
     * encode quotes as &#34; / &#39;. Phalcon 5's "string" filter is htmlspecialchars() instead.
     */
    public static function sanitizeString($value): string
    {
        // FILTER_SANITIZE_STRING also treats "< ...>" (space after "<") as a tag
        $value = preg_replace('/<(?=\s)/', '<_', (string)$value);

        return str_replace(array('"', "'"), array('&#34;', '&#39;'), strip_tags($value));
    }
}
