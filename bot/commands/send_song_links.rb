require 'json'
require_relative '../response'
require_relative '../command'

module Commands
  class SendSongLinks < Command
    def execute
      regex = Regexp.new(
        'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)'
      )
      links = input.text.gsub(regex)
      song_link_api_url = 'https://api.song.link/v1-alpha.1/links?url='
      @links_by_platforms = links.map do |link|
          response = Faraday.get("#{song_link_api_url}#{link}")
          if response.status == 200
            body = JSON.parse(response.body)
            body['linksByPlatform']
          end
      end.compact
    end

    def responses
      links_by_platforms.map do |platform_link|
        Response.new(
          :send_message,
            {
              text: response,
              chat_id: input.chat.id,
              reply_markup: markup(platform_link)
            }
        )
      end
    end

    private

    attr_reader :links_by_platforms

    def markup(platforms)
      required_platforms = {
        appleMusic: true,
        youtubeMusic: true,
        soundcloud: true,
        youtube: true,
        spotify: true
      }
      keyboard = platforms.map do |platform, url|
        if required_platforms[platform.to_sym]
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: platform,
            url: url['url']
          )
        end
      end

      Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
    end

    def response
      [
        'Всех благ ежжи',
        'Шааа!!!',
        'Тааа!!!',
        'Я падаю из пустоты в пустоту, дабы не потерять высоту',
        'Весь мир будет против меня — я прав. Я одно это знаю, и это меня вдохновляет',
        'Безделье — игрушка дьявола',
        'Плотный салам, братья',
        'Угаманис',
        'КРАСИВО ДУШЕВНО',
        'Братан',
        'Мужик',
        'Хопача',
        'Огоооо',
        'Я рядом, брат',
        'Силен не тот, кто насрал, а кто не обосрался',
        'Вы мне не запретите срать!',
        'Ничто не вечно, не стоит бояться перемен',
        'Терпение — залог успеха',
        'Дом там, где висит твоя шляпа и играет твой музон',
        'Как феникс, я восстал из пепла. А вы, горите в моём огне!',
        'Деньги неважны там, куда я иду',
        'Нечестная победа — это не победа. Победа - это когда 9 мая',
        'Кто-то однажды сказал: мальчики и мужчины отличаются только одним — размером своих игрушек. Если это правда, то я как раз стал мужчиной. Или по крайней мере, взрослой черепахой-мутантом.',
        'Прогноз погоды на сегодня: облачно, временами черепашки',
        'Я был в плену поражения, я превратил сердце в камень. Забился в свою скорлупу, пытаясь быть идеальным. Думая, что я был не хорош, что надо быть лучше, а я был зол и... Я был своим худшим врагом',
        'Отлично, ещё один компьютерный чудик',
        'Мусор — это власть',
        'Если хочешь быть моим клоном, тогда цени традиции Бусидо, и честь.',
        'Стены не помогут, если враг внутри',
        'Дорога возникает под шагами идущего.',
        'Говорят, что у всех дорог есть конец, но иногда конец похож на начало, даже если ты прошел очень длинный путь.',
        'То, что я открываю тебе свою боль, еще не означает, что я люблю тебя.',
        'Я не люблю горох.',
        'Любое событие неизбежно, иначе его бы не случилось.'
      ].sample
    end

    def response_for_ed
      'Эд петук'
    end
  end
end
