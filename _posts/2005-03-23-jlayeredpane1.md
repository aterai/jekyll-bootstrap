---
layout: post
category: swing
folder: JLayeredPane1
title: JLayeredPaneで小さなウインドを表示
tags: [JLayeredPane, JPanel, MouseListener, MouseMotionListener]
author: Taka
pubdate: 2005-03-23T18:34:51+09:00
description: 背景画像を表示可能なJLayeredPaneに付箋紙を表示するサンプルです。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTOrYdIcmI/AAAAAAAAAcw/Ol4ZcH6Pw48/s800/JLayeredPane1.png
comments: true
---
## 概要
背景画像を表示可能な`JLayeredPane`に付箋紙を表示するサンプルです。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTOrYdIcmI/AAAAAAAAAcw/Ol4ZcH6Pw48/s800/JLayeredPane1.png %}

## サンプルコード
<pre class="prettyprint"><code>/** 2005/03/24
    JLayeredPane のサンプル
    背景画像を表示する JFrame に JLayeredPane を使って付箋紙を表示する。
    ヘッダー部分のクリックで付箋紙の上下入れ替えを、ドラッグで付箋紙の移
    動を行う。

◎ノート
・Font は環境に合わせて適当に変えるか、コメントアウトして下さい。
・背景画像 bg.gif を用意して下さい。画像がなくても背景なしで動作します。
・テスト WindowsXP/J2SE 5.0
 */
import java.io.File;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.BorderFactory;
import javax.swing.border.Border;

public class TestJLayeredPane1 extends JFrame {
  Font FONT = new Font("ＭＳ ゴシック", Font.PLAIN, 12);
  String BG_IMG = "bg.gif";

  public static void main(String[] argv) {
    TestJLayeredPane1 f = new TestJLayeredPane1();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.setPreferredSize(new Dimension(700, 500));
    f.pack();
    f.setVisible(true);
  }

  static final int BACKLAYER = 1;
  static final int FORELAYER = 2;
  BGImageLayeredPane layerPane;

  public TestJLayeredPane1() {
    super("TestJLayeredPane1");

    //背景画像
    Image img = null;
    File f = new File(BG_IMG);
    if (f.isFile()) {
      ImageIcon icon = new ImageIcon(BG_IMG);
      img = icon.getImage();
    }

    layerPane = new BGImageLayeredPane();
    layerPane.setImage(img);

    for (int i = 0; i &lt; 7; i++) {
      JPanel p = createPanel(i);
      p.setLocation(i * 70 + 20, i * 50 + 15);
      layerPane.add(p, BACKLAYER);
    }
    setContentPane(layerPane);
  }

  int[] colors = { 0xDD_DD_DD, 0xAA_AA_FF, 0xFF_AA_AA, 0xAA_FF_AA, 0xFF_FF_AA, 0xFF_AA_FF, 0xAA_FF_FF };

  Color getColor(int i, float f) {
    int b = (int) ((i &amp; 0xFF) * f);
    i = i &gt;&gt; 8;
    int g = (int) ((i &amp; 0xFF) * f);
    i = i &gt;&gt; 8;
    int r = (int) ((i &amp; 0xFF) * f);
    return new Color(r, g, b);
  }

  JPanel createPanel(int i) {
    String s = "&lt;html&gt;&lt;font color=#333333&gt;ヘッダーだよん:" + i + "&lt;/font&gt;&lt;/html&gt;";
    JLabel label = new JLabel(s);
    label.setFont(FONT);
    label.setOpaque(true);
    label.setHorizontalAlignment(SwingConstants.CENTER);
    label.setBackground(getColor(colors[i], .85f));
    Border border1 = BorderFactory.createEmptyBorder(4, 4, 4, 4);
    label.setBorder(border1);

    JTextArea text = new JTextArea();
    text.setBackground(new Color(colors[i]));
    text.setMargin(new Insets(4, 4, 4, 4));
    text.setLineWrap(true);

    JPanel p = new JPanel();

    Color col = getColor(colors[i], .5f);
    Border border = BorderFactory.createLineBorder(col, 1);
    p.setBorder(border);

    //ウインド移動用の処理
    DragMouseListener li = new DragMouseListener(p);
    p.addMouseListener(li);
    p.addMouseMotionListener(li);

    p.setLayout(new BorderLayout());
    p.add(label, BorderLayout.NORTH);
    p.add(text);
    p.setSize(new Dimension(150, 120));
    return p;
  }

  //タイトル部分のマウスクリックでパネルを最上位にもってくる。ドラッグで移動。
  class DragMouseListener implements MouseListener, MouseMotionListener {
    Point origin;
    JPanel panel;

    DragMouseListener(JPanel p) {
      panel = p;
    }
    @Override public void mousePressed(MouseEvent e) {
      origin = new Point(e.getX(), e.getY());
      //選択された部品を上へ
      layerPane.moveToFront(panel);
    }
    @Override public void mouseDragged(MouseEvent e) {
      if (origin == null) return;

      //ずれた分だけ JPanel を移動させる
      int dx = e.getX() - origin.x;
      int dy = e.getY() - origin.y;
      Point p = panel.getLocation();
      panel.setLocation(p.x + dx, p.y + dy);
    }

    @Override public void mouseClicked(MouseEvent e) {}
    @Override public void mouseEntered(MouseEvent e) {}
    @Override public void mouseExited(MouseEvent e) {}
    @Override public void mouseReleased(MouseEvent e) {}
    @Override public void mouseMoved(MouseEvent e) {}
  }

  //背景画像を描画する JLayeredPane
  class BGImageLayeredPane extends JLayeredPane {
    BGImageLayeredPane() {}

    void setImage(Image img) {
      bgImage = img;
    }
    Image bgImage;

    @Override public void paint(Graphics g) {
      if (bgImage != null) {
        int imageh = bgImage.getHeight(null);
        int imagew = bgImage.getWidth(null);

        Dimension d = getSize();
        for (int h = 0; h &lt; d.getHeight(); h += imageh) {
          for (int w = 0; w &lt; d.getWidth(); w += imagew) {
            g.drawImage(bgImage, w, h, this);
          }
        }
      }
      super.paint(g);
    }
  }
}
</code></pre>

## 解説
`JLayeredPane`のサブクラス`BGImageLayeredPane`で背景画像を描画しています。
`JLayeredPane`に`createPanel(int i)`で作った付箋紙の部品を`add`し、マウスリスナーでクリックやドラッグを検出しています。

## 参考リンク
- [JPanelの背景に画像を並べる](https://ateraimemo.com/Swing/BackgroundImage.html)
- [デジタル出力工房　絵写楽](http://www.bekkoame.ne.jp/~bootan/free2.html)

<!-- dummy comment line for breaking list -->

## コメント
- ほかのページで参考になりました。お礼にサンプルを差し上げます。不都合でしたら編集・削除してください。画像と`zip`のアップロードがわからないので、ソースを全部のせてあります・・・あしからず。 -- *Taka* 2005-03-23 (水) 18:34:51
    - ~~下のアイコンからファイルの添付ができるのですが、広告のせいかうまく表示や取得ができなくなっています。いい方法がないかちょっと調べてみます。 -- *aterai* 2005-03-25 (金) 10:04:23~~
    - ~~添付できるようにしてみました。`codehighlight`プラグインとかも入れたいのですが、今後の課題です。 -- *aterai* 2005-03-28 (月) 11:58:48~~
    - あと、言い忘れてましたが、全然不都合は無いです(投稿があるとは思ってませんでしたが)。今後ともよろしくお願いします。 -- *aterai* 2005-03-28 (月) 12:00:03
- 投稿できる環境を作成するのはまだ先になりそうなので、勝手に背景とか用意させてもらいました。 -- *aterai* 2006-06-10 (土) 13:50:27

<!-- dummy comment line for breaking list -->
