---
layout: post
title: JTextAreaに行番号を表示
category: swing
folder: LineNumber
tags: [JTextArea, FontMetrics, JScrollPane]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-02-20

## JTextAreaに行番号を表示
`JTextArea`に行番号を表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTPV_bkDWI/AAAAAAAAAd0/Jktuzx5j5gU/s800/LineNumber.png)

### サンプルコード
<pre class="prettyprint"><code>class LineNumberView extends JComponent {
  private static final int MARGIN = 5;
  private final JTextArea textArea;
  private final FontMetrics fontMetrics;
  //private final int topInset;
  private final int fontAscent;
  private final int fontHeight;
  private final int fontDescent;
  private final int fontLeading;

  public LineNumberView(JTextArea textArea) {
    this.textArea = textArea;
    Font font   = textArea.getFont();
    fontMetrics = getFontMetrics(font);
    fontHeight  = fontMetrics.getHeight();
    fontAscent  = fontMetrics.getAscent();
    fontDescent = fontMetrics.getDescent();
    fontLeading = fontMetrics.getLeading();
    //topInset  = textArea.getInsets().top;

    textArea.getDocument().addDocumentListener(new DocumentListener() {
      @Override public void insertUpdate(DocumentEvent e) {
        repaint();
      }
      @Override public void removeUpdate(DocumentEvent e) {
        repaint();
      }
      @Override public void changedUpdate(DocumentEvent e) {}
    });
    textArea.addComponentListener(new ComponentAdapter() {
      @Override public void componentResized(ComponentEvent e) {
        revalidate();
        repaint();
      }
    });
    Insets i = textArea.getInsets();
    setBorder(BorderFactory.createCompoundBorder(
      BorderFactory.createMatteBorder(0, 0, 0, 1, Color.GRAY),
      BorderFactory.createEmptyBorder(i.top, MARGIN, i.bottom, MARGIN - 1)));
    setOpaque(true);
    setBackground(Color.WHITE);
    setFont(font);
  }
  private int getComponentWidth() {
    Document doc  = textArea.getDocument();
    Element root  = doc.getDefaultRootElement();
    int lineCount = root.getElementIndex(doc.getLength());
    int maxDigits = Math.max(3, String.valueOf(lineCount).length());
    Insets i = getBorder().getBorderInsets(this);
    return maxDigits * fontMetrics.stringWidth("0") + i.left + i.right;
    //return 48;
  }
  private int getLineAtPoint(int y) {
    Element root = textArea.getDocument().getDefaultRootElement();
    int pos = textArea.viewToModel(new Point(0, y));
    return root.getElementIndex(pos);
  }
  @Override public Dimension getPreferredSize() {
    return new Dimension(getComponentWidth(), textArea.getHeight());
  }
  @Override public void paintComponent(Graphics g) {
    g.setColor(getBackground());
    Rectangle clip = g.getClipBounds();
    g.fillRect(clip.x, clip.y, clip.width, clip.height);

    g.setColor(getForeground());
    int base  = clip.y;
    int start = getLineAtPoint(base);
    int end   = getLineAtPoint(base + clip.height);
    int y     = start * fontHeight;
    int rmg   = getBorder().getBorderInsets(this).right;
    for(int i=start;i&lt;=end;i++) {
      String text = String.valueOf(i + 1);
      int x = getComponentWidth() - rmg - fontMetrics.stringWidth(text);
      y += fontAscent;
      g.drawString(text, x, y);
      y += fontDescent + fontLeading;
    }
  }
}
</code></pre>

### 解説
[Advice for editor gutter implementation... | Oracle Forums](https://forums.oracle.com/message/6217372)を参考にして、`JTextArea`に行番号を表示しています。

上記のサンプルで使用する`JTextArea`は、使用するフォントや余白などは変更不可で、各行の高さは最後まで一定であると想定しています。

### 参考リンク
- [Advice for editor gutter implementation... | Oracle Forums](https://forums.oracle.com/message/6217372)
- [Line Number in JTextPane | Oracle Forums](https://forums.oracle.com/message/5782932)
- [line number in jtextpane | Oracle Forums](https://forums.oracle.com/message/6267595)

<!-- dummy comment line for breaking list -->

### コメント
- すごいね！私はこのような資料を探しています、どうも　ありがとうございます。 -- [ＣＫ](http://terai.xrea.jp/ＣＫ.html) 2007-04-21 (Sat) 18:29:31
    - どういたしまして。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-04-23 (月) 09:47:47
- こちらのソースは非常に参考になります。現在趣味でエディタを作成しているのですが、`JTextPane`の`Document`を`JTextArea`に与えてカーソル位置を取得しています。`JTextPane`で行番号、列番号を正確に取得できないものでしょうか？ -- [shusen](http://terai.xrea.jp/shusen.html) 2007-11-09 (金) 10:22:30
- どうもです。`JTextPane`だと、デフォルトの行の折り返しをどう扱うかで、行番号の表示が異なります。   -- [aterai](http://terai.xrea.jp/aterai.html) 2007-11-09 (金) 14:52:40
    - 折り返しても表示は前の行のままの場合
        - [Line Number in JTextPane | Oracle Forums](https://forums.oracle.com/message/5782932)
        - このページのサンプルは、上記のリンク先にある`LineNumberView`(@author Alan Moore)を参考にしていますが、`JTextArea`に必要なさそうな折り返しや各行の高さが異なる場合などの処理を削っているので、`JTextPane`で使う場合は、リンク先などのオリジナルのソースを参考にしてください。
    - 折り返された行にも行番号を表示したい場合
        - [line number in jtextpane | Oracle Forums](https://forums.oracle.com/message/6267595)
        - 上記のリンク先にあるサンプルでは、`EditorKit`を使って行番号を表示しており、`JTextPane`で折り返された行でも、表示に従って行番号が割り振られています。
- ご返答ありがとうございます。現在はこちらにある折り返し抑制のソースを利用させていただいているので、`EditorKit`を利用する分を試してみたいと思います。 -- [shusen](http://terai.xrea.jp/shusen.html) 2007-11-09 (金) 19:16:05
- `EditorKit`を利用した分をｺﾋﾟﾍﾟして、とりあえずそのままコンパイル・実行してみました。ここでおかしいことがありまして、コマンドプロンプトから起動すると文字が挿入された行のみ行番号が表示されるのですが、自作エディタから`ProcessBuilder`と`Process`で`"java Test"`となるように呼び出すと、未入力の行も含めて全ての行番号が表示されます。コレはプロンプトの実効環境がおかしいのでしょうか？ -- [shusen](http://terai.xrea.jp/shusen.html) 2007-11-14 (水) 17:20:54
- すみません、自己解決しました（たぶん）。ランタイムの問題で、`jre1.6.0_01`以下だと上記の状態になりました。`jre1.6.0_02`と`jre1.6.0_03`ではちゃんと表示されました。 -- [shusen](http://terai.xrea.jp/shusen.html) 2007-11-14 (水) 17:31:45
    - 情報ありがとうございます。直接は関係のない話ですが、バージョンかぁと何気にダウンロードサイトに行ったら、~~サーバー落ちてるっぽいですねorz~~ あとで見たらダウンロードのページがすこし変更されているみたいなので、単に更新中だっただけ？みたいです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-11-14 (水) 18:43:29
- ありがとう。参考になりました。 -- [ミルコ・マグカップ](http://terai.xrea.jp/ミルコ・マグカップ.html) 2013-08-08 (木) 16:38:51
- ところで、これってJTextAreaとフォントを同じにしないとgetComponentWidth()で適切な幅が得られないと思います。 -- [ミルコ・マグカップ](http://terai.xrea.jp/ミルコ・マグカップ.html) 2013-08-08 (木) 16:40:32
- getComponentWidth()はJTextAreaのフォントを基に幅を算出しているけど、実際に描画されるフォントはデフォルトのフォントだから -- [ミルコ・マグカップ](http://terai.xrea.jp/ミルコ・マグカップ.html) 2013-08-08 (木) 16:44:11
    - こんばんは。「JTextAreaのフォントの幅...」は、確かにそうですね。この幅は行番号の表示幅とその右寄せにしか使ってないので、いっそ固定にしてもいいかもしれません。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-08-08 (木) 22:24:41
    - `LineNumberView`に`setFont`で同じフォントを使用するように修正しました(ミルコさん、ありがとうございました)。ついでに`JTextArea`のフォントより`RowHeaderView`(行番号表示用)のフォントサイズがすこし小さい場合などでも問題ないように、ベースラインを真面目に揃えて描画するよう修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-08-09 (金) 12:59:25

<!-- dummy comment line for breaking list -->
