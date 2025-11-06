from django.shortcuts import render
from django.views.generic import ListView, CreateView, UpdateView, DetailView, DeleteView
from django.urls import reverse_lazy
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator

from posts.models import BlogPost

class BlogHome(ListView):
    model = BlogPost
    template_name = "home/home.html"
    context_object_name = "posts"

    def get_queryset(self): # Hide not published posts
        queryset = super().get_queryset()
        if self.request.user.is_authenticated:
            return queryset
        return queryset.filter(is_published=True)

@method_decorator(login_required, name='dispatch')
class BlogPostCreate(CreateView):
    model = BlogPost
    template_name = "posts/create.html"
    fields = [
        'title',
        'content',
        'thumbnail',
        'is_published'
    ]

@method_decorator(login_required, name='dispatch')
class BlogPostUpdate(UpdateView):
    model = BlogPost
    template_name = "posts/edit.html"
    fields = [
        'title',
        'content',
        'is_published'
    ]
    success_url = reverse_lazy('home')

class BlogPostDetail(DetailView):
    model = BlogPost
    template_name = "posts/detail.html"
    context_object_name = "post"

@method_decorator(login_required, name='dispatch')
class BlogPostDelete(DeleteView):
    model = BlogPost
    template_name = "posts/confirm_delete.html"
    success_url = reverse_lazy('home')
    context_object_name = "post"