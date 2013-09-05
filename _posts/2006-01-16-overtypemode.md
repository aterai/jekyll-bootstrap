---
layout: post
title: JTextAreaのキャレットを上書きモード対応にする
category: swing
folder: OverTypeMode
tags: [JTextArea, Caret]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-01-16

## JTextAreaのキャレットを上書きモード対応にする
`JTextArea`にキャレット上の文字を上書きする上書きモードを追加します。[Swing - JTextPane edit mode (insert or overwrite)???](https://forums.oracle.com/forums/thread.jspa?threadID=1383467)のソースコードを変更して全角文字対応にしています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTQtaGO6gI/AAAAAAAAAgA/XPqHe-c_DUo/s800/OverTypeMode.png)

### サンプルコード
<pre class="prettyprint"><code>// Paint a horizontal line the width of a column and 1 pixel high
class OvertypeCaret extends DefaultCaret {
  //The overtype caret will simply be a horizontal line
  //one pixel high (once we determine where to paint it)
  public void paint(Graphics g) {
    if(isVisible()) {
      try{
        JTextComponent component = getComponent();
        TextUI mapper = component.getUI();
        Rectangle r = mapper.modelToView(component, getDot());
        g.setColor(component.getCaretColor());
        int width = g.getFontMetrics().charWidth('w');
        //全角などに対応
        if(isOvertypeMode()) {
          int pos = getCaretPosition();
          if(pos&lt;getDocument().getLength()) {
            if(getSelectedText()!=null) {
              width = 0;
            }else{
              String str = getText(pos, 1);
              width = g.getFontMetrics().stringWidth(str);
            }
          }
        } //ここまで追加
        int y = r.y + r.height - 2;
        g.drawLine(r.x, y, r.x + width - 2, y);
      }catch(BadLocationException e) {}
    }
  }
  // Damage must be overridden whenever the paint method is overridden
  // (The damaged area is the area the caret is painted in. We must
  // consider the area for the default caret and this caret)
  protected synchronized void damage(Rectangle r) {
    if(r != null) {
      JTextComponent c = getComponent();
      x = r.x;
      y = r.y;
      //width = c.getFontMetrics(c.getFont()).charWidth('w');
      //全角対応
      width = c.getFontMetrics(c.getFont()).charWidth('あ');
      height = r.height;
      repaint();
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、上書きモード用のキャレットを作成して、<kbd>Insert</kbd>キーで切り替えるようになっています。

上書きモード自体の動作は、`JTextArea#replaceSelection`メソッドをオーバーライドすることで行われています。キー入力があった場合、次の文字までを選択して置き換える処理がこのメソッドに追加されています。

### 参考リンク
- [Swing - JTextPane edit mode (insert or overwrite)???](https://forums.oracle.com/forums/thread.jspa?threadID=1383467)

<!-- dummy comment line for breaking list -->

### コメント
- 改行の処理がまだいい加減です。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-01-16 (月) 15:56:38
- テキストを選択状態にして<kbd>Insert</kbd>キーを押すと、反転されたままになるようなので修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-01-16 (月) 18:45:02
- `IME`起動時、「あ」を入力し、<kbd>変換</kbd>キー（or <kbd>Space</kbd>キー）を押すたびに減っていきます。日本語対応のソースを心待ちにしています。 -- [初心者](http://terai.xrea.jp/初心者.html) 2006-03-24 (金) 10:40:01
- バグですね。報告ありがとうございます。減らないように修正はしたのですが、置換は以下のように適当です。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-24 (金) 16:26:25

<!-- dummy comment line for breaking list -->

	aaaabbbb   //元のテキストの先頭で「ああ」と入力、変換して確定すると
	嗚呼bbbb   //こうならずに
	嗚呼aabbbb //こうなってしまう(まじめにやれば、なんとかなりそうだが)

- 早速のご対応ありがとうございます。m時 -- [初心者](http://terai.xrea.jp/初心者.html) 2006-03-27 (月) 14:09:27
- ごめんなさい。途中で送信してしまいました。文字という点で、半角`１`文字の上書きが全角`１`文字でOKだと個人的には思います。 -- [初心者](http://terai.xrea.jp/初心者.html) 2006-03-27 (月) 14:10:36
- `xyzzy`を参考にして「嗚呼bbbb」の方がいかなと思ったのですが、さっき試した`excel`だと「嗚呼aabbbb」になるみたいです。ので、これは仕様ということにしておきます(^^;。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-27 (月) 15:00:06
- `xyzzy`は使ったことがないのですが、秀丸と同じでしょうか。「嗚呼」に「a」と入力して、「a 呼」なのは、ちょっといやでした。`excel`上書できるんですね。`word`で`IME`起動中に<kbd>Insert</kbd>キー押下したら、ダイアログに驚きました。 -- [初心者](http://terai.xrea.jp/初心者.html) 2006-03-28 (火) 13:05:15
- `xyzzy`でも「a 呼」です。他の文字の位置が上書きで出来るだけ移動しないようにするための処理だと思います。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-31 (金) 16:39:04

<!-- dummy comment line for breaking list -->
