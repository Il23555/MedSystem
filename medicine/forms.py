from django import forms


class AnalysesForm(forms.Form):

    pressure = forms.IntegerField(min_value=30, max_value=200)
    conscience = forms.IntegerField(min_value=0, max_value=10)
    nitrogen = forms.FloatField(min_value=0, max_value=20)
    breath = forms.IntegerField(min_value=0, max_value=60)
    age = forms.IntegerField(min_value=10, max_value=120)
    image = forms.ImageField()
