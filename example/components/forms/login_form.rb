# <form method="post" class="standard_form" id="login_form">
#   <div class="standard_form__field">
#     <label for="email">Email</label>
#     <input type="email"
#            name="email"
#            id="email"
#            class="standard_form__field__input"
#            placeholder="example@example.com" />
#     <div class="standard_form__field__error_label">
#       <label for="<%= for %>"
#              class="standard_form__field__error_label__for">
#         <%= error %>
#       </label>
#     </div>
#   </div>

#   <div class="standard_form__field">
#     <label for="password">Password</label>
#     <input type="password"
#            name="password"
#            id="password"
#            class="standard_form__field__input"
#            placeholder="xxxxxxxx" />
#     <div class="standard_form__field__error_label">
#       <label for="<%= for %>"
#              class="standard_form__field__error_label__for">
#         <%= error %>
#       </label>
#     </div>
#   </div>

#   <div class="standard_form__buttons">
#     <button type="submit"
#             class="standard_form__buttons__button">
#       Login
#     </button>
#   </div>
# </form>
#
Component.new(:login_form, html: { form: { method: :post } },
                           stylesheet: :standard_form,
                           uses: [:error_label]) do
  field do
    label(for: :email) { 'Email' }
    input(type: :email,
          name: :email,
          id: :email,
          value: user.email,
          placeholder: 'example@example.com')
    error_label(errors: user.errors.email,
                for: :password)
  end

  field do
    label(for: :password) { 'Password' }
    input(type: :password,
          name: :password,
          id: :password,
          value: user.password,
          placeholder: 'xxxxxxxx')
    error_label(errors: user.errors.password
                for: :password)
  end

  buttons do
    button(type: :submit) { 'Login' }
  end
end
