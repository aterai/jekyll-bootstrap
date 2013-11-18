---
layout: post
title: JFrameの透明化と再描画
category: swing
folder: TranslucentFrameRepaint
tags: [JFrame, Translucent, JPanel, JLabel, TexturePaint]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-10-24

## JFrameの透明化と再描画
半透明にした`JFrame`の再描画を行います。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-ujoDf8eD4vE/TqLcC0f2CHI/AAAAAAAABD4/LHaXXW6HW1k/s800/TranslucentFrameRepaint.png)

### サンプルコード
<pre class="prettyprint"><code>private final SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss");
private final JLabel label = new JLabel(df.format(new Date()));
private final Timer timer = new Timer(1000, new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    label.setText(df.format(new Date()));
    if(label.getParent().isOpaque()) {
      repaintWindowAncestor(label);
    }
  }
});
private void repaintWindowAncestor(Component c) {
  Window w = SwingUtilities.getWindowAncestor(c);
  if(w instanceof JFrame) {
    JFrame f = (JFrame)w;
    JComponent cp = (JComponent)f.getContentPane();
    //cp.repaint();
    Rectangle r = c.getBounds();
    r = SwingUtilities.convertRectangle(c, r, cp);
    cp.repaint(r.x, r.y, r.width, r.height);
    //r = SwingUtilities.convertRectangle(c, r, f);
    //f.repaint(r.x, r.y, r.width, r.height);
  }else{
    c.repaint();
  }
}
//or
//private void repaintWindowAncestor(JComponent c) {
//  JRootPane root = c.getRootPane();
//    Rectangle r = c.getBounds();
//    r = SwingUtilities.convertRectangle(c, r, root);
//    root.repaint(r.x, r.y, r.width, r.height);
//  }
</code></pre>

### 解説
上記のサンプルでは、実際は`JFrame`が半透明ではなく、以下のように~~半透明にした~~透明にした`JFrame`に、半透明の`JPanel`を追加、さらにその子として一秒ごとに文字列が変化する`JLabel`(時計)を配置しています。

- `JFrame`
    - 透明
        
        <pre class="prettyprint"><code>com.sun.awt.AWTUtilities.setWindowOpaque(frame, false);
        //frame.setBackground(new Color(0,0,0,0)); //1.7.0
</code></pre>
    - `AWTUtilities.setWindowOpacity(...)`、`Window#setOpacity(...)`は、子コンポーネントを含めてすべて半透明になるので、このサンプルでは使用していない

<!-- dummy comment line for breaking list -->

- `JPanel`
    - `frame.getContentPane().add(panel)`で追加
    - 半透明(二種類)
        - `setOpaque(true)`+半透明のアルファ成分をもつ色を`setBackground()`で設定
        - `JPanel`が`setOpaque(true)`なので、`ContentPane`から再描画しないと、`JPanel`に設定した半透明の背景色が重複して上書きされる(色が濃くなる)
        - `setOpaque(false)`+`paintComponent()`をオーバーライドして背景画像などを描画

<!-- dummy comment line for breaking list -->

- `JLabel`
    - `panel.add(label)`で追加
    - 一秒ごとに文字列を変更する時計
    - `setOpaque(false)`で背景は透明

<!-- dummy comment line for breaking list -->

### 参考リンク
- [江戸の文様（和風素材・デスクトップ壁紙）](http://www.viva-edo.com/komon/edokomon.html)
- [ユアネーム・7セグ・12セグフォント大全集](http://www.yourname.jp/soft/digitalfonts-20090306.shtml)

<!-- dummy comment line for breaking list -->

### コメント
- フォントをデジタル時計ぽいものに変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-02-10 (金) 17:35:12
    - スクリーンショットは入れ替えるのが面倒なので、古いフォントのまま。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-04-17 (火) 17:26:14

<!-- dummy comment line for breaking list -->

