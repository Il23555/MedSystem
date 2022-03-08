from django.shortcuts import render
from django.http import HttpResponseRedirect

from fuzzylogic.FuzzySystem import FuzzySystem
from medicine.forms import AnalysesForm


def index(request):
    return render(request, 'medicine/index.html', {})


def analyses(request):
    if request.method == 'POST':
        form = AnalysesForm(request.POST)
        if form.is_valid():
            pressure = form.cleaned_data['pressure']
            conscience = form.cleaned_data['conscience']
            nitrogen = form.cleaned_data['nitrogen']
            breath = form.cleaned_data['breath']
            age = form.cleaned_data['age']

            fuzzy_system = FuzzySystem()
            fuzzy_result = fuzzy_system.query(pressure, conscience, nitrogen, breath, age)

            return render(request, 'medicine/result.html', {'results': fuzzy_result})
    else:
        form = AnalysesForm()

    return render(request, 'medicine/analyses.html', {'form': form})

