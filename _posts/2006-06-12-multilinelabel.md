---
layout: post
category: swing
folder: MultiLineLabel
title: JTextPane、JLabelなどで複数行を表示
tags: [JLabel, JTextArea, JTextPane]
author: aterai
pubdate: 2006-06-12T10:49:21+09:00
description: JTextPane、JTextArea、JLabelを使った複数行のラベルをテストします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQPZi7whI/AAAAAAAAAfQ/ynZxQGkn3_A/s800/MultiLineLabel.png
comments: true
---
## 概要
`JTextPane`、`JTextArea`、`JLabel`を使った複数行のラベルをテストします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQPZi7whI/AAAAAAAAAfQ/ynZxQGkn3_A/s800/MultiLineLabel.png %}

## サンプルコード
<pre class="prettyprint"><code>private final JTextPane label1 = new JTextPane();
private final JTextArea label2 = new JTextArea();
private final JLabel    label3 = new JLabel();
public MainPanel() {
  super(new GridLayout(3, 1));
  ImageIcon icon = new ImageIcon(getClass().getResource("wi0124-32.png"));

  SimpleAttributeSet attr = new SimpleAttributeSet();
  StyleConstants.setLineSpacing(attr, -.2f);
  label1.setParagraphAttributes(attr, true);

  label1.setText("JTextPane\nasdfasdf");
  label2.setText("JTextArea\nasdfasdf");
  label3.setText("&lt;html&gt;JLabel+html&lt;br&gt;asdfasdf");
  label3.setIcon(icon);

  add(setLeftIcon(label1, icon));
  add(setLeftIcon(label2, icon));
  add(label3);

  setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
  setPreferredSize(new Dimension(320, 160));
}
private static Box setLeftIcon(JTextComponent label, ImageIcon icon) {
  label.setForeground(UIManager.getColor("Label.foreground"));
  //label.setBackground(UIManager.getColor("Label.background"));
  label.setOpaque(false);
  label.setEditable(false);
  label.setFocusable(false);
  label.setMaximumSize(label.getPreferredSize());
  label.setMinimumSize(label.getPreferredSize());

  JLabel l = new JLabel(icon);
  l.setCursor(Cursor.getDefaultCursor());
  Box box = Box.createHorizontalBox();
  box.add(l);
  box.add(Box.createHorizontalStrut(2));
  box.add(label);
  box.add(Box.createHorizontalGlue());
  return box;
}
</code></pre>

## 解説
- 上: `JTextPane`
    - 文字色、背景色を変更し、編集不可、フォーカスの取得不可にした`JTextPane`を使用
    - `\n`を使用して改行
    - `SimpleAttributeSet`を使用して、行間を詰めている
- 中: `JTextArea`
    - 文字色、背景色を変更し、編集不可、フォーカスの取得不可にした`JTextArea`を使用
    - `\n`を使用して改行
- 下: `JLabel` + `html`
    - `JLabel`の文字列に`html`タグを使用
    - `<br>`タグを使用して改行

<!-- dummy comment line for breaking list -->

## 参考リンク
- [XP Style Icons - Download](https://xp-style-icons.en.softonic.com/)
- [JEditorPaneやJTextPaneに行間を設定する](https://ateraimemo.com/Swing/LineSpacing.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JDK 6`で、`html`タグを使った`JLabel`での複数行表示がすこし変更(それとも自分の環境のフォントなどが変わっただけ？)されている？ようです(`Windows`環境)。行間が詰まって見易くなっているようで、わざわざ`JTextPane`+`SimpleAttributeSet`で行間を調節する必要もなさそうです。 -- *aterai* 2007-01-10 (水) 12:44:53
- `label.setBackground(UIManager.getColor("Label.background"));`(いつの間にか白になっていた)を`label.setOpaque(false);`に変更しました。 -- *aterai* 2007-10-01 (月) 12:12:55
- はじめまして。`Java`初心者なのですが、`JLabel`で英字フォントを指定するとギザギザで表示されるのですが、ギザギザをなくすにはどうしたらよいでしょうか？ネットで探すと`setRenderingHint`を使うとできると出てはくるのですが、`JLabel`を使った場合の例が出てこなくて。。。ご教授よろしくお願いします。 -- *ばしばし* 2007-10-17 (水) 20:16:10
    - こんばんは。[「Java SE 6完全攻略」第17回 文字に対するアンチエイリアス：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20070205/260649/)にいろんな環境での方法がまとめられています。自宅の環境(`Windows XP` + `java1.6.0_03`)では、以下のようにオプションを設定して起動するとアンチエイリアスが掛かるようです(`XP`の画面のプロパティ、デザイン、効果を`ClearType`に変更してもなぜかうまくいかない…)。 -- *aterai* 2007-10-17 (水) 21:54:38

<!-- dummy comment line for breaking list -->

	java -Dawt.useSystemAAFontSettings=on -cp ".\target\classes" example.MainPanel

- ありがとうございます。なるほど、いろいろ書かれていますね！明日試してみます！ -- *ばしばし* 2007-10-17 (水) 23:59:34
- こんにちは。当方の環境が`JDK1.5`なので、非標準の`-Dswing.aatext=true`を設定するとアンチエイリアスがかかりました。けれども、標準ではどうするのかと言う疑問が。。。 -- *ばしばし* 2007-10-18 (木) 09:37:28
    - ども。Sunに「`1.5`にも標準のオプション用意して」とお願いする…のはひとまず置いといて…。`Java Swing Hacks`本では、テキストにアンチエイリアスを適用するためだけの`Look & Feel`([Wrap Look And Feel - L2FProd.com](http://wraplf.l2fprod.com/))を使用する方法が紹介(`HACK#52`)されています。これを使えば、`-Dswing.aatext=true`無しで、`1.5`でもアンチエイリアスが掛かります。 -- *aterai* 2007-10-18 (木) 14:42:33
    - もし、一部の`JLabel`をアンチエイリアスするだけでいいのなら、以下のように`JLabel#paintComponent`メソッドをオーバーライドしてしまうのが手っ取り早いかもしれません。 -- *aterai* 2007-10-18 (木) 15:16:04

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JLabel label = new JLabel("asdfasdfasdf") {
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2d = (Graphics2D) g;
    g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,
                         RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
    g2d.setRenderingHint(RenderingHints.KEY_RENDERING,
                         RenderingHints.VALUE_RENDER_QUALITY);
    super.paintComponent(g2d);
  }
};
</code></pre>

- お返事遅くなりましたm(__)m。試してみます！ありがとうございます！ -- *ばしばし* 2007-10-22 (月) 09:57:29
- `JLabel`で`html`を使用すると`setEnabled(false)`でグレーアウトしてくれないです。どうしたものでしょう。 -- *ApplePedlar* 2007-12-11 (火) 17:34:00
    - [Bug ID: 4740519 HTML JLabel not greyed out on setEnabled(false)](https://bugs.openjdk.java.net/browse/JDK-4740519)ですね。今のところ、[Swing - JLabel with html tag can not be disabled or setForegroud?!](https://community.oracle.com/thread/1377943)みたいに ~~逃げるしかない？みたいです。~~ する方法があります。 -- *aterai* 2007-12-11 (火) 18:27:05
    - コードが長くなってしまったので、別ページを作成しました。`JEditorPane`を使用する方法も追加しています。[Htmlを使ったJLabelとJEditorPaneの無効化](https://ateraimemo.com/Swing/DisabledHtmlLabel.html) -- *aterai* 2007-12-24 (月) 23:24:50
- こんにちは。ココのおかげでとても助かっています。ところで、`1`行の高さ（文字の高さを含めた高さ）を指定したい、というときには、`setLineSpacing`ではダメってことですよね？「指定したい高さ－フォントの大きさ」を`setLineSpacing`で指定してあげなきゃいけないんですよね？（文字サイズによって`1`行の高さが揃わなくなるのはイヤで揃えたいなと思うのですが、フォントによってそれだと、そうすると、フォントの大きさを変えるたびに指定しなおさなきゃいけないってことですよね。面倒…） -- *びびあず* 2008-10-31 (金) 10:42:47
    - こんにちは。どういたしまして。`LineSpacing`はフォントサイズに依存するみたいですね。固定の間隔を指定するのなら、例えば以下のように、`ParagraphView#getBottomInset`メソッドなどをオーバーライドするのが簡単かも。 -- *aterai* 2008-10-31 (金) 14:36:51
    - ソースコードを[JEditorPaneやJTextPaneに行間を設定する](https://ateraimemo.com/Swing/LineSpacing.html)に移動しました。 -- *aterai* 2009-11-02 (月) 12:54:44
- （変な日本語を書いてましたね、失礼しました。）　ところで…、さっそくご親切にソースまで書いて教えていただけて嬉しいです。ありがとうございました。これを参考にして、また勉強したいと思います。本当にありがとうございました。 -- *びびあず* 2008-11-07 (金) 14:22:27
- `Swing`初心者です。`JTextPane`での複数行表示、大変参考になりました。複数行表示自体はおかげ様でうまくいったのですが、ボーダーが思い通りにならず困っています。`TitledBorder`を設定しているのですが、タイトルを囲む線の外側（コンポーネントの枠）がくぼんだ状態になってしまいます。外枠は表示させたくないのですが、どこかで`OFF`できるのでしょうか。ご教授いただければ幸いです。 -- *ka-ka* 2008-12-25 (木) 00:03:08
    - こんばんは。`TitledBorder`の枠線を変更する場合は、`label.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEmptyBorder(), "title"));`のように、他の`Border`(この場合、`EmptyBorder`で非表示にしている)と組み合わせて使用します。[TitledBorder (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/border/TitledBorder.html#TitledBorder-javax.swing.border.Border-java.lang.String-) -- *aterai* 2008-12-25 (木) 01:46:20
- ありがとうございます。`NetBeans`で開発しているのですが、あ～でもないこ～でもないとプロパティ画面をいじっていたら、`JScrollPane`と`JTextPane`の組み合わせで思い描いたものはできました。`Swing`も`NetBeans`も初めてなので色々と思い通りにできずに四苦八苦しております。。。今後ともこちらのサイトで勉強させていただきます！ -- *ka-ka* 2008-12-26 (金) 00:38:15

<!-- dummy comment line for breaking list -->
