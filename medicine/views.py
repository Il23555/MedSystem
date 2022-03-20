from django.shortcuts import render

from NN.model import PneumoniaModel
from app.settings import MODEL_PATH
from fuzzylogic.FuzzySystem import FuzzySystem
from medicine.forms import AnalysesForm

nn_model = PneumoniaModel(MODEL_PATH)
fuzzy_system = FuzzySystem()


def analyses(request):
    if request.method == 'POST':
        form = AnalysesForm(request.POST, request.FILES)
        if form.is_valid():
            pressure = form.cleaned_data['pressure']
            conscience = form.cleaned_data['conscience']
            nitrogen = form.cleaned_data['nitrogen']
            breath = form.cleaned_data['breath']
            age = form.cleaned_data['age']

            image_field = form.cleaned_data['image']

            nn_predict = nn_model.predict(image_field)
            fuzzy_result = fuzzy_system.query(pressure, conscience, nitrogen, breath, age)

            return render(request, 'medicine/result.html', {'results': [fuzzy_result, nn_predict]})
    else:
        form = AnalysesForm()

    return render(request, 'medicine/analyses.html', {'form': form})
