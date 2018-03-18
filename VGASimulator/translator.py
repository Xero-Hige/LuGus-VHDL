

ONE = "1"
ZERO = "0"

class Translator:

    def bit_to_boolean(self,value):
        trimmed_value = self.clean_value(value)
        if(trimmed_value == ONE):
            return True
        else:
            return False

    def bin_to_int(self,bin_value):
        trimmed_value = self.clean_value(bin_value)
        number_length = len(trimmed_value)
        max_int = (2**number_length) - 1
        return (int(trimmed_value,2)/max_int) * 255

    def to_ns(self,nanoseconds):
        trimmed_value = self.clean_value(nanoseconds)
        trimmed_value = trimmed_value.replace("ns","")
        return int(trimmed_value)

    def clean_value(self, oldvalue):
        return oldvalue.strip().replace('\'','')