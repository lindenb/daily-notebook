class ParseRelatedness:
    class Sample:
        def __init__(self, name):
            self.name = name
            self.count = 0
            self.sum_relatedness = 0.0

        def add_relatedness(self, relatedness):
            self.sum_relatedness += relatedness
            self.count += 1

        def get_average_relatedness(self):
            return self.sum_relatedness / self.count if self.count > 0 else 0.0

    def __init__(self, csv_file_path):
        self.csv_file_path = csv_file_path
        self.samples_dict = {}

    def calculate_average_relatedness_per_sample(self):
        with open(self.csv_file_path, 'r') as file:
            for line in file:
                values = line.strip().split("\t")

                if len(values) == 3:
                    sample1, sample2, relatedness = values
                    relatedness = float(relatedness)

                    self.update_sample(sample1, relatedness)
                    self.update_sample(sample2, relatedness)

    def update_sample(self, sample_name, relatedness):
        sample = self.samples_dict.get(sample_name, self.Sample(sample_name))
        sample.add_relatedness(relatedness)
        self.samples_dict[sample_name] = sample

    def display_results(self):
        for sample in self.samples_dict.values():
            print(f"Echantillon : {sample.name}, Somme des Relatedness : {sample.sum_relatedness}, "
                  f"Nombre de fois rencontré : {sample.count}, "
                  f"Moyenne des Relatedness : {sample.get_average_relatedness()}")


def main():
    csv_file_path = "chemin/vers/votre/fichier.csv"
    parser = ParseRelatedness(csv_file_path)
    parser.calculate_average_relatedness_per_sample()
    parser.display_results()


if __name__ == "__main__":
    main()
