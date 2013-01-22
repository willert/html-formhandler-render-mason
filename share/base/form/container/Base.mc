<%args>
  callback => ( isa => 'CodeRef' )
</%args>

<%method content><% $.callback->() %></%method content>
