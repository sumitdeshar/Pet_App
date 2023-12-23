# models.py
from django.db import models
from django.contrib.auth.models import User, Permission
from django.contrib.contenttypes.models import ContentType
from django.db import transaction

class CommunityProfile(models.Model):
    community_name = models.CharField(max_length=255)
    description = models.TextField()
    members = models.ManyToManyField(User, through='CommunityMembership')
    creation_date = models.DateTimeField(auto_now_add=True)
    cover_photo = models.ImageField(upload_to='community_covers/', blank=True, null=True)

    def __str__(self):
        return self.community_name
    
class CommunityMembership(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    community = models.ForeignKey(CommunityProfile, on_delete=models.CASCADE)
    is_admin = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.user.username} - {self.community.community_name}"

    def make_user_admin(user, community):
        try:
            with transaction.atomic():
                # Assuming there is only one CommunityMembership for a user and community
                community_membership = CommunityMembership.objects.get(user=user, community=community)
                community_membership.is_admin = True
                community_membership.save()
                
                return True  # Indicates success
        except CommunityMembership.DoesNotExist:
            # Handle the case where there is no CommunityMembership for the user
            return False  # Indicates failure

class CommunityMembershipQuestion(models.Model):
    question_text = models.TextField(null=True)
    community = models.ForeignKey(CommunityProfile, on_delete=models.CASCADE)

    def __str__(self):
        return self.question_text

class CommunityMembershipAnswer(models.Model):
    answer_text = models.TextField(null=True)
    question = models.ForeignKey(CommunityMembershipQuestion, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f"Answer by {self.user.username} to '{self.question.question_text}'"
    
class CommunityApplication(models.Model):
    PENDING = 'Pending'
    APPROVED = 'Approved'
    REJECTED = 'Rejected'

    STATUS_CHOICES = [
        (PENDING, 'Pending'),
        (APPROVED, 'Approved'),
        (REJECTED, 'Rejected'),
    ]

    full_name = models.CharField(max_length=100)
    email = models.EmailField()
    why_join = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default=PENDING)

    def __str__(self):
        return f"{self.full_name} - {self.status}"


# Create custom permission for administering the community
def create_custom_permission():
    content_type = ContentType.objects.get_for_model(CommunityMembership)
    permission = Permission.objects.create(
        codename='can_administer_community',
        name='Can administer community',
        content_type=content_type,
    )
    

class Post(models.Model):
    content = models.TextField()
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    community = models.ForeignKey(CommunityProfile, related_name='posts', on_delete=models.CASCADE)
    photo = models.ImageField(upload_to='post_photos/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Post by {self.author.username} in {self.community.name}"

class Comment(models.Model):
    post = models.ForeignKey(Post, related_name='comments', on_delete=models.CASCADE)
    content = models.TextField()
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Comment by {self.author.username} on {self.post}"

class Upvote(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, related_name='upvotes', null=True, blank=True, on_delete=models.CASCADE)
    comment = models.ForeignKey(Comment, related_name='upvotes', null=True, blank=True, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        if self.post:
            return f"{self.user.username} upvoted post in {self.post.community.name}"
        elif self.comment:
            return f"{self.user.username} upvoted comment by {self.comment.author.username}"

