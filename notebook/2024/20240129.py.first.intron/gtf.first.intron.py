import sys
class Transcript:
    def __init__(self, chrom,strand, transcript_id):
        self.chrom = chrom
        self.strand = strand
        self.transcript_id = transcript_id
        self.exons = []

    def print_first_intron(self):
        # Trier les exons par position
        sorted_exons = sorted(self.exons, key=lambda exon: exon[0])

        # Si le transcript a au moins deux exons, calculer l'intron entre le premier et le deuxième exon
        if len(sorted_exons) >= 2:
            # En fonction de la direction (strand), retourner les coordonnées de l'intron
            if self.strand == '+':
                intron_start, intron_end = sorted_exons[0][1] +1 ,sorted_exons[1][0] - 1
            elif self.strand == '-':
                intron_start, intron_end = sorted_exons[-2][1]+1 ,sorted_exons[-1][0]- 1
            else:
                raise ValueError("Invalid value for 'strand'. Must be '+' or '-'.")

            print(f"{self.chrom}\t{intron_start -1}\t{intron_end}\t{self.strand}\t{self.transcript_id}")
        else:
            return None

def filter_gtf_by_type():
    transcripts = {}

    for line in sys.stdin:
        if line.startswith('#'):
            continue

        fields = line.strip().split('\t')
        if len(fields) < 9:
            continue

        feature = fields[2]
        if feature == "exon":
            transcript_id = None
            strand = fields[6]  # La colonne 7 (index 6) contient l'information sur le strand

            attributes = fields[8].split(';')
            for attr in attributes:
                if 'transcript_id' in attr:
                    transcript_id = attr.split('"')[1]

            if transcript_id:
                if transcript_id not in transcripts:
                    transcripts[transcript_id] = Transcript(fields[0],strand,transcript_id)

                start, end = int(fields[3]), int(fields[4])
                transcripts[transcript_id].exons.append((start, end))

    return transcripts

# Exemple d'utilisation
exon_transcripts = filter_gtf_by_type()

for tr   in exon_transcripts.values():
    tr.print_first_intron()
