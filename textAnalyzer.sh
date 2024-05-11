#!/bin/bash

# Один и тот же кусок кода для вывода ошибки
# можно поместить в функцию
error() {
	echo "Ошибка: $1"
	echo "Использование: $0 <входной_файл> <выходной_файл> -d <слово>"
	exit 1
}

echo "Здравствуйте!"
echo "Вы используете скрипт TextAnalyzer."
echo "Он предназначен для анализа текста из файла по ключевому параметру."
echo -e

echo "Производится анализ переданных аргументов..."
echo -e

input_file=""
output_file=""

# Сразу проверяем количество переданных аргументов
if [ "$#" -lt 4 ]; then
	error "Неверное количество аргументов!"
fi

# Парсинг аргументов
while [[ -n $1 ]]; do
	case $1 in
	-d)
		if [[ ! -z "$2" ]]; then
			search_word=$2
			shift 2
		else
			break
		fi
		;;
	*)
		if [ ! -n "$input_file" ]; then
			input_file=$1
		elif [ ! -n "$output_file" ]; then
			output_file=$1
		else
			error "Слишком много аргументов!"
		fi
		shift 1
		;;
	esac
done

# Если какая-либо из переменных пуста, это значит, что
# соответствующий аргумент не был передан
if [[ ! -n $output_file ]] || [[ ! -n $input_file ]] || [[ ! -n $search_word ]]; then
	error "Неверные аргументы!"

# Если входного файла не существует
elif [[ ! -f "$input_file" ]]; then
	error "Входного файла не существует!"
fi

echo "Результаты анализа:"
echo "Входной файл: $input_file"
echo "Выходной файл: $output_file"
echo "Параметр: $search_word"
echo -e
echo "Считаю количество вхождений..."

# Если передали точку, то экранируем
if [[ $search_word == "." ]]; then
	search_word="\."
fi

# Подсчет слов
count=$(cat "$input_file" | grep -o "$search_word" | wc -l)

# Если ранее экранировали точку, возвращаем обратно
if [[ $search_word == "\." ]]; then
	search_word="."
fi

echo "Успешно!"
echo -e
echo "Записываю вердикт в файл $output_file..."

# Склонение в зависимости от количества слов
if [ $count -le 10 ] || [ $count -ge 20 ]; then
	if [ $((count % 10)) -eq 0 ] || [ $((count % 10)) -ge 5 ] && [ $((count % 10)) -le 9 ]; then
		echo "Параметр \"$search_word\" встретился $count раз." >$output_file
	elif [ $((count % 10)) -eq 1 ]; then
		echo "Параметр \"$search_word\" встретился $count раз." >$output_file
	else
		echo "Параметр \"$search_word\" встретился $count раза." >$output_file
	fi
else
	echo "Параметр \"$search_word\" встретился $count раз." >$output_file
fi

echo "Вердикт записан!"
echo -e

echo "До новых встреч!"
