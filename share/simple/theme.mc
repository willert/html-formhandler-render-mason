<%flags>
  extends => 'form.mp'
</%flags>

<%around label>
  <label><% $self->$orig( @_ ) %></label>
</%around>


<%around container>
  <% $self->$orig( @_ ) %>
</%around>

<%around field>
  <div class="form-field">
    <% $self->$orig( @_ ) %>
  </div>
</%around>

<%around form>
  <% $self->$orig( @_ ) %>
</%around>

<% $.widget %>
