{{ content() }}

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li class="active">Setting</li>
    </ol>
    <ul>
      <li>{{ link_to('setting/labs', 'Labs') }}</li>
      <ul>
        <li>{{ link_to('setting/users', 'Users') }}</li>
        <li>{{ link_to('setting/projects', 'Projects') }}</li>
      </ul>
      <li>{{ link_to('setting/steps', 'Steps') }}</li>
      <ul>
        <li>{{ link_to('setting/protocols', 'Protocols') }}</li>
        <li>{{ link_to('setting/oligobarcodeSchemes', 'Oligobarcode Schemes') }}</li>
        <li>{{ link_to('setting/oligobarcodes', 'Oligobarcodes') }}</li>
      </ul>
      <li>{{ link_to('setting/samplePropertyTypes', 'Sample Property Types') }}</li>
      <li>{{ link_to('setting/sampleLocations', 'Sample Locations') }}</li>
      <li>{{ link_to('setting/organisms', 'Organisms') }}</li>
      <li>{{ link_to('setting/instrumentTypes', 'Instrument Types') }}</li>
      <ul>
        <li>{{ link_to('setting/instruments', 'Instruments') }}</li>
        <li>{{ link_to('setting/seqRunmodeTypes', 'Sequence Run Mode Types') }}</li>
        <li>{{ link_to('setting/seqRunreadTypes', 'Sequence Run Read Types') }}</li>
        <li>{{ link_to('setting/seqRuncycleTypes', 'Sequence Run Cycle Types') }}</li>
      </ul>
    </ul>
  </div>
</div>
