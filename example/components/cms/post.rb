# <article class="cms_post">
#   <header class="cms_post__header">
#     <h1 class="cms_post__header__title">
#       <%= post.title %>
#     </h1>
#   </header>

#   <section class="cms_post__intro">
#     <%= post.intro %>
#   </section>

#   <section class="cms_post__content">
#     <%= post.content %>
#   </section>

#   <footer class="cms_post__footer">
#     <p>
#       By <cite class="cms_post__footer__cite"><%= post.author.name %></cite>
#     </p>
#   </footer>
# </article>
#
Component.new(:cms_post, html: :article) do
  header do
    h1 { post.title }
  end

  intro(:section) { post.intro }

  content(:section) { post.content }

  footer do
    p { ['By', cite { post.author.name }] }
  end
end
