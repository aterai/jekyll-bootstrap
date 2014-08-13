---
layout: post
title: GridBagLayoutを使ってレンガ状に配置
category: swing
folder: BrickLayout
tags: [GridBagLayout, LayoutManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-03-09

## GridBagLayoutを使ってレンガ状に配置
`GridBagLayout`を使ってコンポーネントをレンガ状に配置します。[Swing - GridBagLayout to create a board](https://forums.oracle.com/thread/1357310)を参考にしています。


{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIOzg1doI/AAAAAAAAASc/V_SwABvAldE/s800/BrickLayout.png %}

### サンプルコード
<pre class="prettyprint"><code>JPanel panel = new JPanel(new GridBagLayout());
panel.setBorder(BorderFactory.createTitledBorder("Brick Layout"));
GridBagConstraints c = new GridBagConstraints();
c.fill = GridBagConstraints.HORIZONTAL;
//c.weightx = 1.0; c.weighty = 0.0;
for(int i=0;i&lt;SIZE;i++) {
  int x = i &amp; 1; //= (i%2==0)?0:1;
  for(int j=0;j&lt;SIZE;j++) {
    c.gridy = i;
    c.gridx = 2*j+x;
    c.gridwidth = 2;
    panel.add(new JButton(" "),c);
  }
}
//&lt;blockquote cite="https://forums.oracle.com/thread/1357310"&gt;
//&lt;dummy-row&gt;
c.gridwidth = 1;
c.gridy = 10;
for(c.gridx=0; c.gridx&lt;=2*SIZE; c.gridx++)
  panel.add(Box.createHorizontalStrut(24), c);
//&lt;/dummy-row&gt;
//&lt;/blockquote&gt;
</code></pre>

### 解説
上記のサンプルでは、`GridBagLayout`を使って、`JButton`をレンガ状に配置します。互い違いに二列ずつ占めるようにボタンを配置していますが、`<dummy-row>`が無い場合、うまくレンガ状にはなりません。

以下、[Swing - GridBagLayout to create a board](https://forums.oracle.com/thread/1357310)のDarryl.Burkeさんの投稿を引用

	A column (or row) in a GridBagLayout is not well defined unless there is at least one component which occupies only that column (or row). All your rows have components spanning 2 columns.

列の基準となる行は、どこでも(先頭でも最後でも)構わないようです。

- - - -
- 同様に、ダミーの幅を持つ行を作成して、キーボード風に配列
    - [java - Laying out a keyboard in Swing - Stack Overflow](http://stackoverflow.com/questions/24622279/laying-out-a-keyboard-in-swing)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class KeyboardTest {
  private static final String[][] keys = {
    {"`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "Backspace"},
    {"Tab", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "\\", ""},
    {"Caps", "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "Enter", ""},
    {"Shift", "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/", "", "\u2191"},
    {" ", " ", " ", "", "                         ", " ", "\u2190", "\u2193", "\u2192"}
  };
  public JComponent makeUI() {
    JPanel keyboard = new JPanel(new GridBagLayout());
    keyboard.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

    GridBagConstraints c = new GridBagConstraints();
    c.weightx = 1d;
    c.weighty = 1d;
    c.fill = GridBagConstraints.BOTH;
    c.gridheight = 1;
    c.gridx = 0;

    c.gridy = 50;
    for (int i = 0; i &lt; keys[0].length * 2; i++) {
      c.gridx = i;
      keyboard.add(Box.createHorizontalStrut(24));
    }

    for (int row = 0; row &lt; keys.length; row++) {
      c.gridx = 0;
      c.gridy = row;
      for (int col = 0; col &lt; keys[row].length; col++) {
        String key = keys[row][col];
        int l = key.length();
        c.gridwidth = l &gt; 10 ? 14 :
                      l &gt; 4  ?  4 :
                      l &gt; 1  ?  3 :
                      l == 1 ?  2 : 1;
        if (l &gt; 2) {
          keyboard.add(new JButton(key), c);
        } else if (key.trim().length() == 0) {
          keyboard.add(Box.createHorizontalStrut(24), c);
        } else {
          keyboard.add(new KeyButton(key), c);
        }
        c.gridx += c.gridwidth;
      }
    }
    return keyboard;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame f = new JFrame("Keyboard");
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new KeyboardTest().makeUI());
    f.setResizable(false);
    f.pack();
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}

class KeyButton extends JButton {
  public KeyButton(String str) {
    super(str);
  }
  @Override public Dimension getPreferredSize() {
    return new Dimension(48, 48);
  }
}
</code></pre>

### 参考リンク
- [Swing - GridBagLayout to create a board](https://forums.oracle.com/thread/1357310)

<!-- dummy comment line for breaking list -->

### コメント
