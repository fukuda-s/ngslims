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

    /**
     * "int" filter of Phalcon 3: a string of digits, "+" and "-" ("" for empty or non-numeric input).
     * Phalcon 5 casts to int, so "" and null become 0 (ex. is_numeric() checks change).
     */
    public static function sanitizeInt($value): string
    {
        return filter_var((string)$value, FILTER_SANITIZE_NUMBER_INT);
    }

    /**
     * "float" filter of Phalcon 3: a string of digits, "+", "-" and "." ("" for empty input).
     */
    public static function sanitizeFloat($value): string
    {
        return filter_var((string)$value, FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
    }
}
