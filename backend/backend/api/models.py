from django.db import models

# Create your models here.
class ContactSubmission(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField()
    phone_number = models.CharField(max_length=20)
    company = models.CharField(max_length=255)
    accepted_terms = models.BooleanField()
    agreed_to_contact = models.BooleanField(default=False)
