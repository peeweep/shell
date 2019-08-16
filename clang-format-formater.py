import sys
import io


def get_len(self):
    len_max = 0
    for i in self.split("\n"):
        if len(i) == 0:
            pass
        elif i[0] == '#':
            pass
        else:
            i = i.replace(" ", '')
            if len(i) > len_max:
                len_max = len(i)
    len_max_option = get_len_max_option(self, len_max)
    return len_max, len_max_option


def get_len_max_option(self, len_max):
    for i in self.split("\n"):
        if len(i) == 0:
            pass
        elif i[0] == '#':
            pass
        else:
            i = i.replace(" ", '')
            if len(i) == len_max:
                index_colon = i.find(':')
                value = i[index_colon+1:]
                len_max_option = len_max - len(value) - 1
    return len_max_option


def sort_str(self):
    len_max, len_max_option = get_len(self)
    list_after_sort = []
    for i in self.split("\n"):
        if len(i) == 0:
            pass
        elif i[0] == '#':
            pass
        else:
            i = i.replace(" ", '')
            len_i = len(i)
            if len_i <= len_max:
                index_colon = i.find(':')
                option = i[:index_colon]
                value = i[index_colon+1:]
                len_space = len_max_option - len(option)
                n = 0
                i = option + ': '
                while len_space > n:
                    i = i + ' '
                    n = n + 1
                i = i + value
        list_after_sort.append(i)
    str_after_sort = ''
    for i in list_after_sort:
        str_after_sort = str_after_sort + '\n' + i
    str_after_sort = ''.join(str_after_sort[1:])
    return str_after_sort


def print_doc():
    description = 'clang-format formater v0.1'
    author = 'Author: Ratbot < Ratbot at GnuPG dot uk >'
    options__help = "-h/--help                        - Display available options"
    options_print = "-p/--print <.clang-format>       - Display the formatted result in the console"
    options_write = "-w/--write <.clang-format>       - Write result to file"
    for i in (description, author, options__help, options_print, options_write):
        print(i)


def options_print(self):
    for i in self.split("\n"):
        print(i)


def options_write(self, file):
    with io.open(file, 'w+', encoding='utf-8') as files:
        files.write(str(self))


def main():

    if len(sys.argv) < 2:
        print_doc()
    else:
        if sys.argv[1] in ("-h", "--help"):
            print_doc()
        elif sys.argv[1] in ("-p", "--print"):
            if len(sys.argv) < 3:
                print_doc()
            else:
                clang_str = io.open(sys.argv[2], 'r', encoding='UTF-8').read()
                str_after_sort = sort_str(clang_str)
                options_print(str_after_sort)
        elif sys.argv[1] in ("-w", "--write"):
            if len(sys.argv) < 3:
                print_doc()
            else:
                clang_str = io.open(sys.argv[2], 'r', encoding='UTF-8').read()
                str_after_sort = sort_str(clang_str)
                options_write(str_after_sort, sys.argv[2])


if __name__ == "__main__":
    main()
