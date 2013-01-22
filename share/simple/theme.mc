<%flags>
  extends => 'form.mp'
</%flags>

<%around label>
  <label><% $self->$orig( @_ ) %></label>
</%around>


<%around container>
  <!-- container -->
    <% $self->$orig( @_ ) %>
  <!-- /container -->
</%around>

<%around field>
  <div class="form-field">
    <% $self->$orig( @_ ) %>
  </div>
</%around>

<%around form>
  <h3><% $form->name || 'Your form' %></h3>
  <% $self->$orig( @_ ) %>
</%around>

<% $.widget %>
