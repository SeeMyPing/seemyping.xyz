from django.db import models
from django.contrib.auth import get_user_model
from django.template.defaultfilters import slugify
from django.urls import reverse

User = get_user_model()

class BlogPost(models.Model):
    title = models.CharField(max_length=255, unique=True, verbose_name="Title")
    slug = models.SlugField(unique=True, max_length=100, blank=True)
    author = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    
    is_published = models.BooleanField(default=False, verbose_name="Published")
    content = models.TextField(blank=True, verbose_name="Content")
    
    thumbnail = models.ImageField(upload_to='thumbnails/', blank=True, null=True)

    updated_at = models.DateTimeField(auto_now=True)
    created_at =  models.DateTimeField(auto_now_add=True, editable=False) #TODO: Make this immutable

    class Meta:
        ordering = ['-created_at']
        verbose_name = "Article"

    def __str__(self):
        return f"{self.title} by {self.author}"
    
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)

    def author_or_default(self):
        return self.author.username if self.author else "unknown"
    
    def get_absolute_url(self):
        return reverse('home')