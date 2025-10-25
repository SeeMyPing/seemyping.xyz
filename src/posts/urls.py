from django.urls import path
from posts.views import BlogPostCreate, BlogPostUpdate, BlogPostDetail, BlogPostDelete

app_name = "posts"

urlpatterns = [
    path('create/', BlogPostCreate.as_view(), name="blog-create"),
    path('edit/<str:slug>', BlogPostUpdate.as_view(), name="blog-edit"),
    path('delete/<str:slug>', BlogPostDelete.as_view(), name="blog-delete"),

    path('<str:slug>/', BlogPostDetail.as_view(), name="post-detail"),
]