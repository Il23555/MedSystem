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

            result_str = concat_results(nn_predict, fuzzy_result)

            return render(request, 'medicine/result.html', {'result_str': result_str})
    else:
        form = AnalysesForm()

    return render(request, 'medicine/analyses.html', {'form': form})


def concat_results(nn_predict, fuzzy_predict):
    if nn_predict == 0 and fuzzy_predict > 1.5 or nn_predict == 1 and fuzzy_predict <= 0.5:
        return 'Ошибка при получении диагностики...'

    if nn_predict == 0:
        if fuzzy_predict <= 0.5:
            return 'Вы здоровы. Поздравляем!'
        elif fuzzy_predict <= 1.5:
            return 'Система не диагностировала пневмонию. Но у вас может быть легкая степень тяжести заболевания. ' \
                   'Рекомендуем амбулаторное лечение!'

    if nn_predict == 1:
        if fuzzy_predict <= 1.5:
            severity = 'легкую'
            treatment = 'амбулаторное'
        elif fuzzy_predict <= 1.5:
            severity = 'среднетяжелую'
            treatment = 'стационарное'
        else:
            severity = 'тяжелую'
            treatment = 'стационарное'
        result = 'Система диагностировала пневмонию. Система определила {} степень тяжести заболевания. ' \
                 'Система рекомендуют {} лечение.'.format(severity, treatment)
        return result
