<%flags>
  extends => 'form.mp'
</%flags>

<%around field>
  <div class="navbar_special">
    <% $self->$orig( @_ ) %>
  </div>
</%around>

<%around form>
  <h3><% $form->name || 'Your form' %></h3>
  <% $self->$orig( @_ ) %>
</%around>

<%around content>
  <hr />
  <% $self->$orig( @_ ) %>
  <hr />
</%around>

<% $.form %>
