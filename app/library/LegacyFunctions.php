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
}
