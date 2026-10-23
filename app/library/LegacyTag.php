<?php

/**
 * Phalcon 3 compatible Tag helpers.
 *
 * Phalcon 5 escapes the text of linkTo(), but views and menus pass HTML
 * (icons, carets, &raquo; etc.) as link text. Output it as is like Phalcon 3.
 * Attributes are still escaped by Phalcon\Tag.
 */
class LegacyTag extends Phalcon\Tag
{
    public static function linkTo($parameters, $text = null, $local = true): string
    {
        if (!is_array($parameters)) {
            $parameters = array($parameters, $text, $local);
        }

        $text = $parameters[1] ?? $parameters['text'] ?? '';
        unset($parameters['text']);

        // Let Phalcon\Tag build the tag around a placeholder, then put the raw text back
        $placeholder = 'LegacyTagText' . bin2hex(random_bytes(8));
        $parameters[1] = $placeholder;

        return str_replace($placeholder, (string)$text, parent::linkTo($parameters));
    }
}
