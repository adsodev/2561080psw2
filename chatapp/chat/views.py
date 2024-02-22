from django.shortcuts import render

# Create your views here.

def sala(request):
    return render(request, 'chat/sala.html')