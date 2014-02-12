<div class="col-md-12">
  {{ flashSession.output() }}
  <p><h1>Your Order</h1></p>
  <button type="button" class="btn btn-info pull-right" id="new-order"
          onclick="location.href='{{ url("order/newOrder") }}'"> New Order <span
        class="glyphicon glyphicon-chevron-right"></span>
  </button>
  <div class="clearfix"></div>
</div>