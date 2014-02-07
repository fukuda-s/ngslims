<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Products extends Phalcon\Mvc\Model
{
    /**
     * @var integer
     */
    public $id;

    /**
     * @var integer
     */
    public $product_types_id;

    /**
     * @var string
     */
    public $name;

    /**
     * @var string
     */
    public $price;

    /**
     * @var string
     */
    public $active;

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    public function initialize()
    {
        $this->belongsTo('product_types_id', 'ProductTypes', 'id', array(
            'reusable' => true
        ));

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Products::NOT_ACTIVE
            )
        ));
    }

}
