import os

from pyswip import Prolog


class FuzzySystem:

    def get_text(self, *data):
        data_list = [str(item) for item in data]
        data_str = ','.join(data_list)

        return data_str

    def get_file_path(self, file_name):
        dir_name = os.path.dirname(__file__)
        file_path = dir_name + '\\' + file_name
        file_path = file_path.replace("\\", "/")

        return file_path

    def query(self, *data):
        prolog = Prolog()
        prolog.consult(self.get_file_path('rules.pl'))

        query_args = self.get_text(*data, 'Y')
        query_text = 'fuzzy_logic(' + query_args + ')'

        results = prolog.query(query_text)
        for result in results:
            return result['Y']



