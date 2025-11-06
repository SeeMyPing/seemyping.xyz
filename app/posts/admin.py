from django.contrib import admin
from posts.models import BlogPost


class BlogPostAdmin(admin.ModelAdmin):
    list_display = ("title", 
                    "is_published", 
                    "created_at", 
                    "updated_at",
     )
    list_editable = (
        "is_published",
    )
admin.site.register(BlogPost, BlogPostAdmin)