---
layout: post
category: swing
folder: ButtonWidth
title: JButtonなどの高さを変更せずに幅を指定
tags: [JButton, LayoutManager, BoxLayout, SpringLayout, GridLayout]
author: aterai
pubdate: 2004-11-29T07:43:03+09:00
description: 高さはデフォルトのまま幅だけを指定して、JButton、JComboBox、JTextFieldなどのサイズを変更します。
image: https://lh5.googleusercontent.com/-B3A8vHPu9_I/UmY7hTtdmtI/AAAAAAAAB4s/7NknsHc_vwI/s800/ButtonWidth.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/10/fixed-width-jbuttons-in-bottom-right.html
    lang: en
comments: true
---
## 概要
高さはデフォルトのまま幅だけを指定して、`JButton`、`JComboBox`、`JTextField`などのサイズを変更します。

{% download https://lh5.googleusercontent.com/-B3A8vHPu9_I/UmY7hTtdmtI/AAAAAAAAB4s/7NknsHc_vwI/s800/ButtonWidth.png %}

## サンプルコード
<pre class="prettyprint"><code>private static JComponent createRightAlignButtonBox2(
  List&lt;JButton&gt; list, final int buttonWidth, int gap) {
  JComponent box = new JPanel() {
    @Override public void updateUI() {
      for (JButton b : list) {
        b.setPreferredSize(null);
      }
      super.updateUI();
      EventQueue.invokeLater(new Runnable() {
        @Override public void run() {
          int maxHeight = list.stream()
            .map(b -&gt; b.getPreferredSize().height)
            .reduce(0, Integer::max);
          Dimension d = new Dimension(buttonWidth, maxHeight);
          for (JButton b : list) {
            b.setPreferredSize(d);
          }
          revalidate();
        }
      });
    }
  };
  box.setLayout(new BoxLayout(box, BoxLayout.X_AXIS));
  box.add(Box.createHorizontalGlue());
  for (JButton b : list) {
    box.add(b);
    box.add(Box.createHorizontalStrut(gap));
  }
  box.setBorder(BorderFactory.createEmptyBorder(gap, 0, gap, 0));
  return box;
}
</code></pre>

## 解説
上記のサンプルでは、`JButton`の高さはデフォルト、幅をその文字列によらずに一定、配置は右寄せで水平にしたい場合のレイアウト方法をテストしています。

- `Default`
    - `BoxLayout`で`Box.createHorizontalGlue()`を使用して右寄せ
    - `JButton`の幅は、その文字列の長さに依存
- `getPreferredSize`
    - `Box`を使用して右寄せ
    - `JButton`の幅は、`JButton#setPreferredSize(...)`で固定幅を設定
    - `JButton`の高さは、`JButton#getPreferredSize()`で取得したサイズの高さを使用
    - `LookAndFeel`を変更すると`JButton`の高さが変化するので、その場合は`JButton#updateUI()`をオーバーライドして`JButton#setPreferredSize(...)`を使用する必要がある
- `SpringLayout`+`Box`
    - [SpringLayoutの使用](https://ateraimemo.com/Swing/SpringLayout.html)
    - `SpringLayout`で幅指定、`BoxLayout`で右寄せ
    - `SpringLayout.Constraints`で`JButton`の固定幅を指定
    - 親パネルの幅も`SpringLayout.Constraints`で固定し、`Box`で入れ子にして右寄せ
    - `LookAndFeel`を変更すると`JButton`の高さが変化するので、その場合は`JComponent#getPreferredSize(...)`をオーバーライドして親パネルの高さを更新する必要がある
- `SpringLayout`
    - [SpringLayoutの使用](https://ateraimemo.com/Swing/SpringLayout.html)
    - `SpringLayout`を使用して右寄せ
    - `SpringLayout.Constraints`で`JButton`の幅を固定
    - `LookAndFeel`を変更すると`JButton`の高さが変化するので、その場合は`JComponent#getPreferredSize(...)`をオーバーライドして親パネルの高さを更新する必要がある
- `GridLayout`+`Box`
    - `GridLayout`で幅指定、`BoxLayout`で右寄せ
    - `GridLayout`ですべての`JButton`のサイズを同じにする
    - `Box`で入れ子にして右寄せ
    - 幅が最大の`JButton`のテキストが変更されると、親の`Box`の幅が変化してしまう

<!-- dummy comment line for breaking list -->

- - - -
以下、`setPreferredSize()`を使用する際の補足、注意点です。

`JButton`の`UI`がフォントサイズや文字列の長さから決めたデフォルトサイズを`getPreferredSize()`で取得しています。高さはそのまま利用し、幅だけ一定の値を設定して、新たなデフォルトサイズを作成し、`setPreferredSize()`しています。これで次から`getPreferredSize()`で返ってくる値は、どちらのボタンでも全く同じになります。

この`setPreferredSize(...)`で設定したサイズは、`LookAndFeel`を変更しても残ってしまう(`DimensionUIResource`を使用しても効果がない)ため、`LookAndFeel`がデフォルトで使用する高さを取得したい場合は、`updateUI()`をオーバーライドして、一旦`JButton#setPreferredSize(null);`を設定して幅を変更した推奨サイズをクリアしてから、`super.updateUI();`で推奨サイズを更新し、その後で固定幅、`LookAndFeel`デフォルトの高さを`setPreferredSize(...)`で設定し直す必要があります。

`getPreferredSize()`で得られる値を使用するかどうかは、レイアウトマネージャーによって異なりますが、水平方向にコンポーネントを並べる`BoxLayout`の場合は以下のようになるため、パネルをリサイズしても、ボタンのサイズはどちらも同じで変化しません。

- 幅: 推奨サイズ(`getPreferredSize`メソッド)から取得した値
- 高さ: 各コンポーネントの推奨サイズ(`getPreferredSize`メソッド)で得られた中からもっとも大きな値
    - 上記のサンプルで`button1.setPreferredSize(new Dimension(100, 0));`としても結果は同じ

<!-- dummy comment line for breaking list -->

例えば、各ボタンを格納した親フレームを`pack()`する前に`JButton#getPreferredSize()`ではなく、`JButton#getSize()`でサイズを取得すると、`[width=0,height=0]`が帰ってきます。コンポーネントが表示されている場合、`getSize()`で得られるサイズは、その実際に表示されているサイズ(レイアウトマネージャーが決定する)になります。

以下は`JLabel`を`getPreferredSize()`した場合の例です。初期状態(`preferredSize`が`null`)の場合は、`JLabel`の`UI`がサイズを計算しています。

<pre class="prettyprint"><code>JLabel l = new JLabel();
l.setText("a"); //preferredSizeがnullの場合、UIがサイズを計算
// l.getPreferredSize() -&gt; Dimension[width=6, height=13]

l.setText("aaaa"); //JLabelの場合、Fontサイズと文字列の長さなどで決まる
// l.getPreferredSize() -&gt; Dimension[width=24, height=13]

l.setText("&lt;html&gt;aa&lt;br&gt;aa");
// l.getPreferredSize() -&gt; Dimension[width=12, height=26]

l.setPreferredSize(new Dimension(10, 10)); //preferredSizeを設定した場合
// l.getPreferredSize() -&gt; Dimension[width=10, height=10]

l.setPreferredSize(null); //preferredSizeをnullに戻した場合
// l.getPreferredSize() -&gt; Dimension[width=12, height=26]
</code></pre>

## 参考リンク
- [JComboBoxなどの幅をカラム数で指定](https://ateraimemo.com/Swing/SetColumns.html)
    - `JComboBox`、`JTextField`などのコンポーネントでは、カラム数による幅の指定が可能
        - `JDK 1.5.0`: カラム数で幅を指定すると、コンポーネントによってサイズや余白などが微妙に異なる
        - `JDK 1.6.0`以上: `LookAndFeel`が同じなら、カラム数での幅指定で、どのコンポーネントでもほぼ同じサイズになる
- [SpringLayoutの使用](https://ateraimemo.com/Swing/SpringLayout.html)
- [Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/how_do_you_layout_command)
    - 専用のレイアウトマネージャーを作成するサンプル
- [JOptionPaneで使用するボタンのサイズを揃える](https://ateraimemo.com/Swing/SameSizeButtons.html)

<!-- dummy comment line for breaking list -->

## コメント
- `SpringLayout`などを使って幅を固定する方法を追加(更新日時は忘れました)。スクリーンショットは未更新。 -- *aterai* 2013-04-14 (日) 00:36:03
- `GridLayout`+`Box`のサンプルを追加、`LookAndFeel`を実行中に変更する場合の注意点を追加、スクリーンショットを更新。 -- *aterai* 2013-10-22 (火) 17:33:58

<!-- dummy comment line for breaking list -->
